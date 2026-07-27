import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../services/bdapps_service.dart';

/// Phone-number entry + bdapps subscription controller.
///
/// Phone persistence is local-only (Hive). Subscription/OTP go through the
/// [BdappsService] against `https://pushtiranna.nestorabyatia.xyz`.
class PhoneAuthController extends GetxController {
  static const _boxName = 'settings';
  static const _phoneKey = 'saved_phone';
  static const _subscribedKey = 'is_subscribed';

  final RxString currentPhone = ''.obs;
  final RxBool isLoading = false.obs;
  final RxString lastError = ''.obs;

  /// Returned by `sendOtp` and required by `verifyOtp`.
  final RxnString referenceNo = RxnString();

  /// Increments whenever the server reports the subscription was revoked
  /// (either from a fresh `checkSubscription` call on launch/resume, or
  /// from an in-app unsubscribe). Watchers (Home, Settings, etc.) should
  /// observe this and bounce the user to `AppRoutes.GATE` when it changes.
  final RxInt subscriptionRevokedAt = 0.obs;

  /// Bumped every time we transition from "subscribed" → "not subscribed".
  /// Unlike [subscriptionRevokedAt] (which can be bumped repeatedly by
  /// background polls that confirm a revoke we already know about), this
  /// only advances on a real edge. UI surfaces (e.g. GateScreen's
  /// "subscription cancelled" snackbar) should call
  /// [consumeRevokeNotification] to read-and-clear it so the same revoke
  /// never produces more than one snackbar.
  final RxInt revokeNotifyCount = 0.obs;

  /// Returns `true` exactly once per fresh `subscribed → not-subscribed`
  /// edge. Background polls that confirm an already-known revoke return
  /// `false`, so the UI does not re-show the same snackbar over and over.
  bool consumeRevokeNotification() {
    final target = revokeNotifyCount.value;
    final current = _lastConsumedRevoke;
    if (target == current) return false;
    _lastConsumedRevoke = target;
    return true;
  }

  int _lastConsumedRevoke = 0;

  Box<String> get _box => Hive.box<String>(_boxName);

  bool get isSubscribed => _box.get(_subscribedKey) == '1';

  /// Latest subscription state reported by bdapps. One of:
  ///   * `'REGISTERED'`         — fully subscribed, full app access
  ///   * `'INITIAL_CHARGING_PENDING'` (or any CHARGING_PENDING variant)
  ///                            — operator has not yet confirmed the first
  ///                              charge; user is in the app but recipes
  ///                              are soft-locked until charging clears
  ///   * `'UNREGISTERED'` / `null` — not subscribed; full app lockout
  ///
  /// UI surfaces (Home, Detail) observe this so a freshly-subscribed user
  /// who hasn't paid their first bill yet can browse the catalogue but
  /// cannot open any individual recipe.
  final RxnString subscriptionStatus = RxnString();

  /// True only when the user has both `is_subscribed = true` AND the
  /// server has confirmed the subscription is fully active (not still
  /// waiting on the operator's first-charge confirmation).
  bool get hasFullAccess =>
      isSubscribed &&
      (subscriptionStatus.value == null ||
          !subscriptionStatus.value!.toUpperCase().contains('CHARGING PENDING'));

  /// Last time the user foregrounded the app. We use this to throttle
  /// resume-time subscription checks so a flurry of app-switches
  /// (open PushtiRanna → switch to messenger → back → WhatsApp → back)
  /// only triggers one network round-trip per foreground window. Without
  /// this, every switch generates a new checkSubscription call and any
  /// transient `isSubscribed: false` reply (network blip, operator
  /// retry) routes the user back to PHONE.
  DateTime _lastResumeCheck = DateTime.fromMillisecondsSinceEpoch(0);

  /// Cooldown between resume-time checks. 60s is short enough to still
  /// catch a real external unsubscribe but long enough to swallow the
  /// rapid-fire false-positives you get while bouncing between apps.
  static const _resumeCheckCooldown = Duration(seconds: 60);

  /// Whether the resume hook should fire a check right now, given the
  /// last-known foreground time. Used by [_AppLifecycleHook].
  bool get shouldResumeCheckNow {
    return DateTime.now().difference(_lastResumeCheck) >= _resumeCheckCooldown;
  }

  /// Record that we just fired a resume check. Called from inside
  /// [checkSubscription] so it reflects the *actual* call time, not the
  /// hook time (which can be delayed).
  void _noteResumeCheck() {
    _lastResumeCheck = DateTime.now();
  }

  Future<void> markSubscribed() async {
    await _box.put(_subscribedKey, '1');
    // Reset the one-shot revoke notification so a *future* revoke can
    // notify the user, but a stale revoke from before this resubscribe
    // never does.
    _lastConsumedRevoke = revokeNotifyCount.value;
  }

  Future<void> markUnsubscribed() async {
    await _box.delete(_subscribedKey);
  }

  // -- local persistence -----------------------------------------------------

  Future<void> savePhone(String phone) async {
    currentPhone.value = phone;
    await _box.put(_phoneKey, phone);
  }

  Future<String?> getSavedPhone() async {
    final p = _box.get(_phoneKey);
    currentPhone.value = p ?? '';
    return p;
  }

  Future<void> clearSavedPhone() async {
    currentPhone.value = '';
    referenceNo.value = null;
    await _box.delete(_phoneKey);
  }

  /// Strip spaces, dashes, parentheses; ensure E.164 `+<digits>` shape.
  String normalizePhone(String input) {
    var p = input.trim();
    p = p.replaceAll(RegExp(r'[\s\-()]'), '');
    if (p.startsWith('+')) return p;
    if (p.startsWith('00')) return '+${p.substring(2)}';
    if (p.startsWith('0')) return '+88$p';
    return '+88$p';
  }

  /// True if the phone looks like E.164 (e.g. +8801834268008).
  /// Allows 8–15 digits after the `+` so partial-typed numbers don't crash
  /// but still rejects obviously invalid input.
  bool isValidPhone(String phone) =>
      RegExp(r'^\+\d{8,15}$').hasMatch(phone);

  // -- bdapps API ------------------------------------------------------------

  /// bdapps expects E.164 *without* the `+` sign:
  /// e.g. `8801834268008` instead of `+8801834268008`.
  String _forApi(String phone) =>
      phone.startsWith('+') ? phone.substring(1) : phone;

  /// `true` if the user is subscribed on the server.
  ///
  /// The PHP `check_subscription.php` returns several shapes depending on
  /// what bdapps reports. We accept any of the following as "active":
  ///   * `isSubscribed === true`
  ///   * `subscriptionStatus` containing `CHARGING PENDING` /
  ///     `CHARGING_PENDING` / `CHARGE PENDING` (first-charge not yet
  ///     confirmed; the user IS subscribed, the operator just hasn't
  ///     billed yet)
  ///   * `subscriptionStatus === "REGISTERED"` (or `"registered"`)
  ///   * `statusCode === "S1000"` and no explicit `isSubscribed === false`
  ///
  /// If the response is *explicitly* "not subscribed" (`isSubscribed
  /// === false` or `subscriptionStatus === "UNREGISTERED"`) we treat
  /// that as a real revoke and clear local state so GateScreen routes
  /// the user back to the subscription flow.
  ///
  /// Anything else — network errors, transient E1951 getStatus errors,
  /// empty payloads — is **not** treated as a revoke here. The
  /// [_AppLifecycleHook] on resume runs `checkSubscription` on every
  /// foreground, and a flaky network must never log a real subscriber
  /// out of the app. Callers that want the strict "lock me out on any
  /// ambiguity" behaviour (GateScreen on cold start) can read
  /// [subscriptionStatus] / [isSubscribed] and route accordingly.
  ///
  /// On detecting a real revoke we also clear the cached phone number
  /// only when requested (the lifecycle hook passes `clearPhone: false`
  /// so the user doesn't have to re-type their number), and bump
  /// [subscriptionRevokedAt] so screens can react.
  Future<bool> checkSubscription() async {
    final phone = currentPhone.value;
    if (phone.isEmpty) return false;
    isLoading.value = true;
    lastError.value = '';
    // Stamp the resume time as soon as we *actually* hit the network —
    // _AppLifecycleHook uses this together with the cooldown to avoid
    // hammering bdapps (and risking a transient revoke) on every
    // foreground bounce.
    _noteResumeCheck();
    try {
      final data = await BdappsService.checkSubscription(_forApi(phone));
      debugPrint('[PhoneAuth] checkSubscription response: $data');

      final v = data['isSubscribed'];
      final explicitActive = v == true || v == 'true';
      final explicitInactive = v == false || v == 'false';
      final statusCode = data['statusCode']?.toString().toUpperCase();
      final subStatus =
          data['subscriptionStatus']?.toString().toUpperCase() ?? '';
      final statusDetail =
          (data['statusDetail'] ?? data['message'] ?? '').toString();

      // bdapps uses INITIAL CHARGING PENDING / CHARGING_PENDING /
      // CHARGE_PENDING while the operator is still confirming the first
      // charge on a freshly-subscribed user. During that window the
      // subscriptionStatus is not REGISTERED yet, and `isSubscribed`
      // comes back as `false` even though the user IS in fact subscribed
      // and shouldn't be locked out. Treat any pending-charge state as
      // active so we don't drop the user back to PHONE on every resume
      // (e.g. when the user opens another app and returns, or taps the
      // system share sheet and comes back).
      final isChargingPending = subStatus.contains('CHARGING PENDING') ||
          subStatus.contains('CHARGE PENDING');

      // The user is "active" if any of these hold:
      //   * bdapps said so explicitly (`isSubscribed: true`)
      //   * the subscription is awaiting its first charge
      //   * the response is clean (S1000 / REGISTERED) without an
      //     explicit `isSubscribed: false` override
      final active = explicitActive ||
          isChargingPending ||
          (!explicitInactive &&
              (statusCode == 'S1000' || subStatus == 'REGISTERED'));

      // "Explicitly revoked" means bdapps is unambiguous: the user
      // really did unsubscribe (or never was subscribed). Anything else —
      // a transient S1000 with no subscriptionStatus, an empty body, an
      // E1951 transient error — leaves the existing local flag alone.
      // This is what stops the resume hook from kicking the user out
      // every time the network blinks.
      final isExplicitlyRevoked = explicitInactive ||
          subStatus == 'UNREGISTERED' ||
          subStatus == 'UNSUBSCRIBED';

      // Publish the latest status so the UI can react (Home can show a
      // "first charge pending" hint, Detail can soft-lock recipes, etc.).
      // Done unconditionally — even on the not-subscribed branch below —
      // so the UI never shows a stale value from a previous check.
      subscriptionStatus.value = subStatus.isEmpty ? null : subStatus;

      if (active) {
        // Make sure the local `is_subscribed` flag is set, even when the
        // server reports charging-pending (where `isSubscribed` comes
        // back false). Without this, `_AppLifecycleHook.didChange…
        // resumed` short-circuits because its own `isSubscribed` guard
        // would be false, AND the next cold start would re-route the
        // user back to PHONE through GateScreen.
        if (isChargingPending || !isSubscribed) {
          await markSubscribed();
        }
        if (isChargingPending) {
          debugPrint(
              '[PhoneAuth] charging-pending treated as active: "$subStatus"');
        }
        return true;
      }

      if (isExplicitlyRevoked) {
        // The user has genuinely unsubscribed. Clear local state so
        // GateScreen routes them back to the subscription flow, and
        // keep the saved phone number on disk so they don't have to
        // re-type it — the OTP step will go straight back to HOME if
        // they re-subscribe from the landing page.
        await _handleRevoked(clearPhone: false, detail: statusDetail);
        return false;
      }

      // Ambiguous / transient response (network glitch, S1000 with no
      // payload, etc.). Do NOT flip `is_subscribed` — that would lock
      // a paying subscriber out of the app every time they switch to
      // another app and come back. Surface the raw status for the UI
      // and return the previous belief so the caller leaves the user
      // where they were.
      debugPrint(
          '[PhoneAuth] ambiguous subscription response, leaving state alone: '
          '"$subStatus" (statusCode=$statusCode)');
      return isSubscribed;
    } on BdappsException catch (e) {
      lastError.value = e.message;
      return false;
    } catch (e) {
      lastError.value = 'Could not check subscription: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Shared cleanup used by [checkSubscription] and any future
  /// server-driven revoke path. Centralised so the side-effects stay in
  /// one place (mark flag, clear phone, bump the revoke-counter).
  ///
  /// `wasSubscribed` is the local belief *before* we clear the flag — it
  /// tells us whether this is a real `subscribed → not-subscribed` edge
  /// (notify the UI) or just background noise confirming an already-known
  /// revoke (don't notify again).
  Future<void> _handleRevoked({
    bool clearPhone = false,
    String detail = '',
  }) async {
    final wasSubscribed = isSubscribed;
    await markUnsubscribed();
    if (clearPhone) {
      await clearSavedPhone();
    }
    if (wasSubscribed) {
      debugPrint('[PhoneAuth] subscription revoked: "$detail"');
      subscriptionRevokedAt.value += 1;
      revokeNotifyCount.value += 1;
    }
  }

  /// Sends a 6-digit OTP. Stores the `referenceNo` for the next step.
  ///
  /// Returns one of:
  ///   * `true`  — OTP issued, `referenceNo` stored, call [verifyOtp] next.
  ///   * `false` — hard failure; `lastError` is set.
  ///   * `'already'` — server says the number is already registered (E1351 /
  ///     `user already registered`). No `referenceNo` will be issued; the
  ///     caller should check subscription and proceed to HOME if active.
  Future<Object> sendOtp() async {
    final phone = currentPhone.value;
    if (phone.isEmpty) {
      lastError.value = 'No phone number saved';
      return false;
    }
    isLoading.value = true;
    lastError.value = '';
    try {
      final data = await BdappsService.sendOtp(_forApi(phone));
      debugPrint('[PhoneAuth] sendOtp response: $data');

      // bdapps sends `referenceNo: null` for every kind of failure (already
      // registered, operator not allowed, etc.). Treat that as a hard fail
      // rather than storing the literal string "null" — otherwise the next
      // verifyOtp call would forward "null" as the reference and the server
      // would return E1854 "Could not find OTP".
      final rawRef = data['referenceNo'];
      final ref = rawRef is String && rawRef.isNotEmpty && rawRef != 'null'
          ? rawRef
          : null;

      final code = data['statusCode']?.toString().toUpperCase();
      final detail = (data['statusDetail'] ?? data['message'] ?? '')
          .toString()
          .toLowerCase();

      // Already-subscribed detection: bdapps returns E1351 with
      // "user already registered" / "already registered" / "subscribed".
      final alreadyRegistered = code == 'E1351' ||
          detail.contains('already registered') ||
          detail.contains('already subscribed') ||
          detail.contains('user registered');

      if (ref == null) {
        if (alreadyRegistered) {
          // Don't surface this as a hard error — the user is simply already
          // on the subscription list. Caller will hit checkSubscription.
          return 'already';
        }
        lastError.value = detail.isNotEmpty
            ? detail
            : 'No reference number returned (status ${code ?? 'unknown'})';
        return false;
      }

      referenceNo.value = ref;
      return true;
    } on BdappsException catch (e) {
      lastError.value = e.message;
      return false;
    } catch (e) {
      lastError.value = 'Could not send OTP: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Verifies [otp] using the stored reference number.
  Future<bool> verifyOtp(String otp) async {
    final rawRef = referenceNo.value;
    if (rawRef == null || rawRef.isEmpty || rawRef == 'null') {
      lastError.value = 'No OTP request in progress';
      return false;
    }
    final ref = rawRef;
    isLoading.value = true;
    lastError.value = '';
    try {
      final data = await BdappsService.verifyOtp(otp, ref);
      debugPrint('[PhoneAuth] verifyOtp response: $data');

      // The PHP layer translates bdapps' verify response into isValid.
      // Be lenient: accept either an explicit isValid, an S1000 statusCode,
      // or a subscriptionStatus of REGISTERED.
      final isValidFlag = data['isValid'];
      final statusCode = data['statusCode']?.toString().toUpperCase();
      final subStatus =
          data['subscriptionStatus']?.toString().toUpperCase();

      final ok = isValidFlag == true ||
          isValidFlag == 'true' ||
          statusCode == 'S1000' ||
          subStatus == 'REGISTERED';

      if (ok) {
        await markSubscribed();
        // Ask the server for the latest status so the cached value matches
        // bdapps's view (also primes GateScreen on next cold launch).
        // Swallow any error here — we already have a positive verify.
        try {
          await BdappsService.checkSubscription(_forApi(currentPhone.value));
        } catch (_) {}
        return true;
      }

      final detail = (data['statusDetail'] ??
              data['message'] ??
              data['statusCode'] ??
              'Server did not confirm the OTP')
          .toString();
      lastError.value = 'OTP not accepted: $detail';
      return false;
    } on BdappsException catch (e) {
      debugPrint('[PhoneAuth] verifyOtp BdappsException: ${e.message}');
      lastError.value = e.message;
      return false;
    } catch (e, st) {
      debugPrint('[PhoneAuth] verifyOtp caught: $e\n$st');
      lastError.value = 'Could not verify OTP: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Cancels the bdapps subscription for the currently saved phone.
  ///
  /// The PHP layer (`unsubscribe.php`) returns:
  ///   * `{ "success": true, "statusCode": "S1000",
  ///       "subscriptionStatus": "UNREGISTERED", ... }`  — happy path
  ///   * `{ "success": false, "statusCode": "E...", "statusDetail": "..." }`
  ///     — bdapps rejected the request (e.g. E1325 already unregistered)
  ///
  /// Success is determined as: `data.success === true`,
  /// OR `data.statusCode === 'S1000'`, OR `subscriptionStatus === 'UNREGISTERED'`.
  Future<bool> unsubscribe() async {
    final phone = currentPhone.value;
    if (phone.isEmpty) {
      lastError.value = 'No phone number saved';
      return false;
    }
    isLoading.value = true;
    lastError.value = '';
    try {
      final data = await BdappsService.unsubscribe(_forApi(phone));
      debugPrint('[PhoneAuth] unsubscribe response: $data');

      final ok = data['success'] == true ||
          data['success'] == 'true' ||
          data['statusCode']?.toString().toUpperCase() == 'S1000' ||
          (data['subscriptionStatus']?.toString().toUpperCase() ==
              'UNREGISTERED');

      if (ok) {
        // Server says the subscription is cancelled. Clear local state so
        // GateScreen routes the user back to subscription flow, and bump
        // the one-shot revoke notification so the first time the gate
        // re-routes the user to PHONE after this unsubscribe we surface
        // the "subscription cancelled" snackbar — but only this once.
        await markUnsubscribed();
        await clearSavedPhone();
        revokeNotifyCount.value += 1;
        return true;
      }

      final detail = (data['statusDetail'] ??
              data['message'] ??
              data['statusCode'] ??
              'Unsubscribe failed')
          .toString();
      lastError.value = 'Unsubscribe failed: $detail';
      return false;
    } on BdappsException catch (e) {
      lastError.value = e.message;
      return false;
    } catch (e) {
      lastError.value = 'Could not unsubscribe: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    currentPhone.value = _box.get(_phoneKey) ?? '';
    // Register the app-lifecycle observer so a user who unsubscribes from
    // the landing page (or any other bdapps surface) is forced back to the
    // gate the next time the app comes to the foreground.
    _lifecycleObserver = _AppLifecycleHook(this);
    WidgetsBinding.instance.addObserver(_lifecycleObserver!);
  }

  @override
  void onClose() {
    final obs = _lifecycleObserver;
    _lifecycleObserver = null;
    if (obs != null) {
      WidgetsBinding.instance.removeObserver(obs);
    }
    super.onClose();
  }

  _AppLifecycleHook? _lifecycleObserver;
}

/// Bridges [WidgetsBinding] lifecycle callbacks into [PhoneAuthController].
///
/// On every `AppLifecycleState.resumed` we re-validate the cached
/// subscription against `check_subscription.php`. If bdapps confirms the
/// user is no longer subscribed, the controller clears local state and
/// the screens (Home, Settings, Gate) observe the bump and route to the
/// gate. Network errors and ambiguous responses are swallowed: a flaky
/// connection must never kick the user out of the app on its own — the
/// source of truth has to be an explicit "not subscribed" answer from
/// bdapps (`isSubscribed: false` or `subscriptionStatus: UNREGISTERED`).
///
/// Note: the `isSubscribed` short-circuit below means that, if a user
/// has somehow lost the local flag (e.g. a previous run revoked them),
/// we deliberately skip the resume check rather than re-revoke. The
/// next cold start will route them through GateScreen which does the
/// authoritative re-check.
class _AppLifecycleHook extends WidgetsBindingObserver {
  _AppLifecycleHook(this._controller);

  final PhoneAuthController _controller;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) return;
    if (_controller.currentPhone.value.isEmpty) return;
    if (!_controller.isSubscribed) return;
    if (!_controller.shouldResumeCheckNow) return;
    // Fire-and-forget. checkSubscription treats charging-pending and
    // ambiguous/transient responses as "leave state alone" — only an
    // explicit `isSubscribed: false` / `UNREGISTERED` will clear the
    // local flag and bump subscriptionRevokedAt.
    unawaited(_controller.checkSubscription());
  }
}
