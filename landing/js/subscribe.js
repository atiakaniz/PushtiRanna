/* =====================================================================
   PushtiRanna landing — Subscribe modal
   Mirrors the Flutter PhoneAuthController flow against the bdapps PHP
   endpoints at https://pushtiranna.nestorabyatia.xyz
   ===================================================================== */
(() => {
  'use strict';

  // ---------- Config ----------
  const API_BASE = 'https://pushtiranna.nestorabyatia.xyz';
  const ENDPOINTS = {
    sendOtp: `${API_BASE}/send_otp.php`,
    verifyOtp: `${API_BASE}/verify_otp.php`,
    checkSubs: `${API_BASE}/check_subscription.php`,
    unsubscribe: `${API_BASE}/unsubscribe.php`,
  };
  const STORAGE_PHONE = 'pushtiranna_phone';
  const STORAGE_SUB   = 'pushtiranna_subscribed';
  const PHONE_REGEX   = /^01[3-9][0-9]{8}$/;         // 11-digit BD mobile (01XXXXXXXXX)
  const DISPLAY_FMT   = (p) => `+880 ${p.slice(1, 5)}-${p.slice(5)}`;

  /**
   * Accept any of these user-entered forms and return the canonical
   * 11-digit `01XXXXXXXXX`, or null if the input isn't valid:
   *   1XXXXXXXXX                       (10 digits — what the input field gives us)
   *   01XXXXXXXXX                      (11 digits — local format)
   *   8801XXXXXXXXX / +8801XXXXXXXXX   (13 digits with country code)
   */
  function normalizePhone(digits) {
    if (!digits) return null;
    let d = digits.replace(/\D/g, '');
    // Strip leading 880 (country code)
    if (d.startsWith('880') && d.length === 13) d = d.slice(3);
    // Prepend leading 0 if user typed the local 10-digit form
    if (d.length === 10 && d.startsWith('1')) d = '0' + d;
    return PHONE_REGEX.test(d) ? d : null;
  }

  // ---------- Element refs ----------
  const els = {};
  document.addEventListener('DOMContentLoaded', init);

  function init() {
    cacheElements();
    bindTriggers();
    restoreState();
    hydrateHeaderButtons();
  }

  function cacheElements() {
    const $ = (s, root = document) => root.querySelector(s);
    const $$ = (s, root = document) => Array.from(root.querySelectorAll(s));

    els.modal       = $('#subscribeModal');
    els.closeBtns   = $$('[data-subscribe-close]');
    els.panes       = $$('.step-pane');
    els.errorNodes  = $$('[data-error]', els.modal);

    // Unsubscribe modal — separate DOM tree, scoped lookups
    els.unsubModal      = $('#unsubscribeModal');
    els.unsubCloseBtns  = $$('[data-unsubscribe-close]');
    els.unsubOpenBtns   = $$('[data-unsubscribe-open]');
    els.unsubConfirmBtn = $('[data-action="confirm-unsubscribe"]');
    els.unsubError      = $('#unsubscribeModal [data-error]');
    els.unsubDisplayPhone = $('[data-display-unsubscribe-phone]');

    // Phone step
    els.phoneForm   = $('#phoneForm');
    els.phoneInput  = $('#phoneInput');
    els.phoneError  = els.phoneForm.querySelector('[data-error]');

    // OTP step
    els.otpForm     = $('#otpForm');
    els.otpCells    = $$('[data-otp-cell]', els.otpForm);
    els.displayPhone = $('[data-display-phone]');

    // Submit buttons (each step has its own)
    els.submitButtons = {
      sendOtp:   $('[data-action="send-otp"]',   els.phoneForm),
      verifyOtp: $('[data-action="verify-otp"]', els.otpForm),
    };

    // Resend / back
    els.resendBtn = $('[data-action="resend"]');
    els.backBtn   = $('[data-action="back-to-phone"]');

    // Header / CTA Subscribe buttons (update label based on state)
    els.subscribeBtns = $$('.subscribe-btn');

    // User account menu (Download APK / Unsubscribe / Log out)
    els.userMenu         = $('#userMenu');
    els.userMenuTrigger  = $('#userMenuTrigger');
    els.userMenuPanel    = $('#userMenuPanel');
    els.userMenuNumber   = $('[data-display-user-phone]');
    els.userLogoutBtn    = $('[data-user-logout]');
  }

  function bindTriggers() {
    // Open
    $$('[data-subscribe-open]').forEach(btn =>
      btn.addEventListener('click', openModal));

    // Close (backdrop + × button)
    els.closeBtns.forEach(btn =>
      btn.addEventListener('click', closeModal));

    // Unsubscribe modal triggers
    els.unsubOpenBtns.forEach(btn =>
      btn.addEventListener('click', (e) => {
        closeUserMenu();
        openUnsubscribeModal(e);
      }));
    els.unsubCloseBtns.forEach(btn =>
      btn.addEventListener('click', closeUnsubscribeModal));
    if (els.unsubConfirmBtn) {
      els.unsubConfirmBtn.addEventListener('click', handleConfirmUnsubscribe);
    }

    // User account menu — open/close, outside-click, Esc, log out
    if (els.userMenuTrigger) {
      els.userMenuTrigger.addEventListener('click', (e) => {
        e.stopPropagation();
        toggleUserMenu();
      });
    }
    if (els.userMenuPanel) {
      // Prevent clicks inside the panel from bubbling to the document
      // listener (otherwise the panel would close immediately).
      els.userMenuPanel.addEventListener('click', (e) => e.stopPropagation());
    }
    if (els.userLogoutBtn) {
      els.userLogoutBtn.addEventListener('click', handleLogout);
    }
    document.addEventListener('click', (e) => {
      if (!els.userMenu || els.userMenu.hidden) return;
      if (els.userMenu.contains(e.target)) return;
      closeUserMenu();
    });
    window.addEventListener('resize', closeUserMenu);

    // Phone form submit
    els.phoneForm.addEventListener('submit', (e) => {
      e.preventDefault();
      handleSendOtp();
    });

    // Strip non-digits live + auto-prepend leading 0 if user pastes full 11-digit form
    els.phoneInput.addEventListener('input', () => {
      const digits = els.phoneInput.value.replace(/\D/g, '');
      // If they paste/type 11 digits starting with 0, show the local 10-digit form
      // (the +880 chip handles the country code visually)
      const trimmed = digits.startsWith('0') && digits.length === 11
        ? digits.slice(1)
        : digits;
      els.phoneInput.value = trimmed.slice(0, 11); // allow up to 11 while editing
      clearErrors();
    });

    // OTP inputs — auto-advance, focus mgmt, paste
    els.otpCells.forEach((cell, idx) => {
      cell.addEventListener('input', () => onOtpCellInput(cell, idx));
      cell.addEventListener('keydown', (e) => onOtpCellKeydown(e, idx));
      cell.addEventListener('paste', onOtpPaste);
    });

    els.otpForm.addEventListener('submit', (e) => {
      e.preventDefault();
      handleVerifyOtp();
    });

    els.resendBtn.addEventListener('click', handleResend);
    els.backBtn.addEventListener('click', goToStepPhone);

    // Escape to close
    document.addEventListener('keydown', (e) => {
      if (e.key !== 'Escape') return;
      if (els.unsubModal && !els.unsubModal.hidden) {
        closeUnsubscribeModal();
      } else if (!els.modal.hidden) {
        closeModal();
      } else if (els.userMenu && !els.userMenu.hidden &&
                 els.userMenuPanel && els.userMenuPanel.classList.contains('is-open')) {
        closeUserMenu();
      }
    });
  }

  // Tiny utility re-declared locally to avoid relying on script.js order
  function $$(s, root = document) { return Array.from(root.querySelectorAll(s)); }

  // ---------- Modal open/close ----------
  function openModal(e) {
    if (e) e.preventDefault();

    // If header badge says subscribed, still allow re-open of flow (e.g. change number)
    els.modal.hidden = false;
    els.modal.setAttribute('aria-hidden', 'false');
    document.body.classList.add('modal-open');

    // If we already have a phone cached but flow was interrupted, jump to OTP
    const cachedPhone = sessionStorage.getItem(STORAGE_PHONE);
    if (cachedPhone && referenceNo()) {
      showPhone(cachedPhone);
      goToStep('otp');
    } else {
      goToStep('phone');
    }

    // Focus first input
    setTimeout(() => {
      const active = els.modal.querySelector('.step-pane.is-active input');
      if (active) active.focus();
    }, 50);
  }

  function closeModal() {
    els.modal.hidden = true;
    els.modal.setAttribute('aria-hidden', 'true');
    document.body.classList.remove('modal-open');
    clearErrors();
  }

  // ---------- Unsubscribe modal ----------
  // Mirrors openModal/closeModal but for a separate DOM tree. We keep the
  // modal-open body class only when one is visible so background scrolling
  // behaves identically to the subscribe flow.
  function openUnsubscribeModal() {
    // Normalize on read so we display the same local-form number we'll POST.
    const phone = normalizePhone(localStorage.getItem(STORAGE_PHONE) || '') || '';
    if (els.unsubDisplayPhone) {
      els.unsubDisplayPhone.textContent = phone
        ? DISPLAY_FMT(phone)
        : '—';
    }
    if (els.unsubError) {
      els.unsubError.textContent = '';
      els.unsubError.hidden = true;
    }
    if (els.unsubConfirmBtn) {
      els.unsubConfirmBtn.disabled = false;
      const label = els.unsubConfirmBtn.querySelector('.btn-label');
      const spinner = els.unsubConfirmBtn.querySelector('.btn-spinner');
      if (label) label.textContent = 'Yes, cancel my subscription';
      if (spinner) spinner.hidden = true;
    }
    els.unsubModal.hidden = false;
    els.unsubModal.setAttribute('aria-hidden', 'false');
    document.body.classList.add('modal-open');
    // Focus the "Keep" button so Enter / Space doesn't immediately fire the
    // destructive primary — the user can arrow-up or click to confirm.
    setTimeout(() => {
      const keepBtn = els.unsubModal.querySelector('[data-unsubscribe-close].btn-secondary');
      keepBtn && keepBtn.focus();
    }, 50);
  }

  function closeUnsubscribeModal() {
    els.unsubModal.hidden = true;
    els.unsubModal.setAttribute('aria-hidden', 'true');
    document.body.classList.remove('modal-open');
  }

  /// Submit handler for the unsubscribe confirmation.
  /// Mirrors handleSendOtp's UX: spinner on, button disabled, server POST,
  /// then a success or inline error state.
  async function handleConfirmUnsubscribe() {
    // The PHP endpoint expects the local 11-digit `01XXXXXXXXX` form —
    // not the 13-digit `8801XXXXXXXXX` country-code form. `normalizePhone`
    // strips any leading `88`/`880` so the server's regex passes.
    const stored = localStorage.getItem(STORAGE_PHONE);
    const phone = normalizePhone(stored || '');
    if (!phone) {
      showError(els.unsubError, 'No active subscription found for this device.');
      return;
    }

    const btn = els.unsubConfirmBtn;
    const label = btn && btn.querySelector('.btn-label');
    const spinner = btn && btn.querySelector('.btn-spinner');
    if (btn) btn.disabled = true;
    if (label) label.textContent = 'Cancelling…';
    if (spinner) spinner.hidden = false;

    try {
      const res = await postForm(ENDPOINTS.unsubscribe, { user_mobile: phone });
      const data = await res.json().catch(() => ({}));

      // Normalize the response so we can match a few alternate shapes
      // coming back from bdapps / our PHP wrapper.
      const code    = (data.statusCode || data.code || '').toString().toUpperCase();
      const status  = (data.subscriptionStatus || '').toString().toUpperCase();
      const detail  = (data.statusDetail || data.detail || '').toString();
      const successFlag = data.success === true || data.success === 'true';
      const errorFlag   = data.success === false || data.success === 'false';
      const errorText   = (data.error || data.message || '').toString();
      const alreadyUnreg =
        status === 'UNREGISTERED' ||
        /already\s*un[_\s-]?registered/i.test(detail) ||
        /format\s*of\s*the\s*address\s*is\s*invalid/i.test(detail);

      // ----- Success paths -----
      //   - bdapps S1000 with UNREGISTERED status
      //   - PHP wrapper reports success:true
      //   - server says "already unregistered" (treat as success so the
      //     user's local state stays consistent with the carrier)
      const ok = res.ok && (
        successFlag ||
        code === 'S1000' ||
        status === 'UNREGISTERED' ||
        alreadyUnreg
      );

      if (ok) {
        markUnsubscribed();
        closeUnsubscribeModal();
        showToast(
          alreadyUnreg && !successFlag && code !== 'S1000'
            ? 'No active subscription was found. You can resubscribe anytime.'
            : 'Subscription cancelled. You can resubscribe anytime.'
        );
        return;
      }

      // ----- Error paths -----
      const shown = (errorFlag && (errorText || detail))
        ? `${errorText || 'Unsubscribe failed'}: ${detail || code || 'unknown error'}`
        : (detail || code || errorText ||
           'The server could not cancel your subscription. Please try again.');
      showError(els.unsubError, shown);
    } catch (err) {
      console.error('[unsubscribe]', err);
      showError(els.unsubError,
        'Could not reach the server. Check your connection and try again.');
    } finally {
      if (btn) btn.disabled = false;
      if (label) label.textContent = 'Yes, cancel my subscription';
      if (spinner) spinner.hidden = true;
    }
  }

  /// Minimal one-shot toast — avoids pulling in a notification library
  /// for a single line of feedback. Auto-dismisses after 3.5s.
  function showToast(message) {
    let toast = document.getElementById('appToast');
    if (!toast) {
      toast = document.createElement('div');
      toast.id = 'appToast';
      toast.setAttribute('role', 'status');
      toast.setAttribute('aria-live', 'polite');
      // Inline styles — keeps it self-contained without a CSS edit.
      Object.assign(toast.style, {
        position: 'fixed',
        left: '50%',
        bottom: '24px',
        transform: 'translateX(-50%)',
        background: '#1B5E20',
        color: '#fff',
        padding: '12px 18px',
        borderRadius: '10px',
        boxShadow: '0 8px 24px rgba(0,0,0,0.2)',
        fontSize: '0.92rem',
        zIndex: '9999',
        opacity: '0',
        transition: 'opacity .25s ease',
        pointerEvents: 'none',
        maxWidth: '90vw',
        textAlign: 'center',
      });
      document.body.appendChild(toast);
    }
    toast.textContent = message;
    // Force reflow so the transition fires from opacity 0 → 1.
    void toast.offsetWidth;
    toast.style.opacity = '1';
    clearTimeout(toast._hideTimer);
    toast._hideTimer = setTimeout(() => {
      toast.style.opacity = '0';
    }, 3500);
  }

  // ---------- Step transitions ----------
  function goToStep(name) {
    els.panes.forEach(p => {
      const match = p.dataset.step === name;
      p.classList.toggle('is-active', match);
      p.hidden = !match;
    });
    clearErrors();
  }

  function goToStepPhone() {
    referenceNo(null);
    goToStep('phone');
    setTimeout(() => els.phoneInput.focus(), 50);
  }

  // ---------- Phone step ----------
  async function handleSendOtp() {
    const raw = (els.phoneInput.value || '').replace(/\D/g, '');
    const normalized = normalizePhone(raw);
    if (!normalized) {
      showError(els.phoneError,
        'Please enter a valid Bangladeshi mobile number (e.g. 01712345678).');
      els.phoneInput.focus();
      return;
    }

    setLoading(els.submitButtons.sendOtp, true);
    clearErrors();

    try {
      const res = await postForm(ENDPOINTS.sendOtp, { user_mobile: normalized });
      const data = await res.json().catch(() => ({}));

      // ----- Error paths -----
      if (!res.ok && res.status !== 200) {
        throw new Error(`HTTP ${res.status}`);
      }

      // E1351 = "already registered" — treat as auto-success
      const code = (data.statusCode || data.code || '').toString();
      const detail = (data.statusDetail || data.detail || '').toString();

      if (code === 'E1351' || /already\s*(registered|subscribed)/i.test(detail)) {
        markSubscribed(normalized);
        showPhone(normalized);
        goToStep('success');
        return;
      }

      // Any explicit error from server
      if (data.success === false || (code && code.startsWith('E'))) {
        showError(els.phoneError, humanError(code, detail));
        return;
      }

      // Happy path
      if (data.referenceNo || code === 'S1000' || data.success) {
        referenceNo(data.referenceNo);
        showPhone(normalized);
        goToStep('otp');
        setTimeout(() => els.otpCells[0]?.focus(), 80);
        return;
      }

      // Fallback: assume success and try to verify
      referenceNo(data.referenceNo);
      showPhone(normalized);
      goToStep('otp');
    } catch (err) {
      console.error('[sendOtp]', err);
      showError(els.phoneError,
        'Could not reach the subscription server. Please check your connection and try again.');
    } finally {
      setLoading(els.submitButtons.sendOtp, false);
    }
  }

  async function handleResend() {
    const phone = (els.displayPhone.textContent || '').replace(/\D/g, '');
    const normalized = normalizePhone(phone);
    if (!normalized) {
      goToStepPhone();
      return;
    }
    // Re-trigger send flow with the local 10-digit form (input field strips leading 0)
    els.phoneInput.value = normalized.slice(1);
    await handleSendOtp();
  }

  // ---------- OTP step ----------
  function onOtpCellInput(cell, idx) {
    const v = cell.value.replace(/\D/g, '');
    cell.value = v;
    cell.classList.toggle('is-filled', v.length > 0);

    if (v && idx < els.otpCells.length - 1) {
      els.otpCells[idx + 1].focus();
    }

    // Auto-submit when all cells filled
    if ([...els.otpCells].every(c => c.value.length === 1)) {
      setTimeout(() => els.otpForm.requestSubmit(), 80);
    }

    // Enable/disable verify button
    els.submitButtons.verifyOtp.disabled =
      ![...els.otpCells].every(c => c.value.length === 1);
  }

  function onOtpCellKeydown(e, idx) {
    if (e.key === 'Backspace' && !els.otpCells[idx].value && idx > 0) {
      els.otpCells[idx - 1].focus();
    } else if (e.key === 'ArrowLeft' && idx > 0) {
      els.otpCells[idx - 1].focus();
    } else if (e.key === 'ArrowRight' && idx < els.otpCells.length - 1) {
      els.otpCells[idx + 1].focus();
    }
  }

  function onOtpPaste(e) {
    const digits = (e.clipboardData?.getData('text') || '')
      .replace(/\D/g, '').slice(0, 6);
    if (!digits) return;
    e.preventDefault();
    digits.split('').forEach((d, i) => {
      if (els.otpCells[i]) {
        els.otpCells[i].value = d;
        els.otpCells[i].classList.add('is-filled');
      }
    });
    const last = Math.min(digits.length, els.otpCells.length) - 1;
    els.otpCells[Math.max(0, last)].focus();
    if (digits.length === els.otpCells.length) {
      setTimeout(() => els.otpForm.requestSubmit(), 80);
    }
  }

  async function handleVerifyOtp() {
    const otp = els.otpCells.map(c => c.value).join('');
    if (otp.length !== 6) {
      showError(els.otpForm.querySelector('[data-error]'), 'Enter all 6 digits.');
      return;
    }

    const ref = referenceNo();
    if (!ref) {
      showError(els.otpForm.querySelector('[data-error]'),
        'Verification session expired. Please request a new code.');
      return;
    }

    const phone = sessionStorage.getItem(STORAGE_PHONE);
    if (!phone || !PHONE_REGEX.test(phone)) {
      goToStepPhone();
      return;
    }

    setLoading(els.submitButtons.verifyOtp, true);
    clearErrors();

    try {
      const res = await postForm(ENDPOINTS.verifyOtp, {
        user_mobile: phone,
        Otp: otp,
        referenceNo: ref,
      });
      const data = await res.json().catch(() => ({}));

      const code = (data.statusCode || data.code || '').toString();
      const detail = (data.statusDetail || data.detail || '').toString();

      // Success conditions
      const ok =
        data.success === true ||
        ['S1000', 'REGISTERED', 'SUBSCRIBED'].includes(code) ||
        /success|registered|verified/i.test(detail);
      if (ok) {
        markSubscribed(phone);
        goToStep('success');
        return;
      }

      // E1854 = OTP not found / expired → allow resend
      if (code === 'E1854') {
        showError(els.otpForm.querySelector('[data-error]'),
          'Code expired or invalid. Tap Resend to get a new one.');
        clearOtp();
        return;
      }

      showError(els.otpForm.querySelector('[data-error]'),
        humanError(code, detail));
      clearOtp();
    } catch (err) {
      console.error('[verifyOtp]', err);
      showError(els.otpForm.querySelector('[data-error]'),
        'Could not reach the subscription server. Please try again.');
    } finally {
      setLoading(els.submitButtons.verifyOtp, false);
    }
  }

  // ---------- State helpers ----------
  function referenceNo(v) {
    if (arguments.length === 0) return sessionStorage.getItem('pushtiranna_ref');
    if (v === null) sessionStorage.removeItem('pushtiranna_ref');
    else sessionStorage.setItem('pushtiranna_ref', v);
    return v;
  }

  function markSubscribed(phone) {
    localStorage.setItem(STORAGE_PHONE, phone);
    localStorage.setItem(STORAGE_SUB, '1');
    sessionStorage.removeItem('pushtiranna_ref');
    hydrateHeaderButtons();
  }

  /// Mirror of markSubscribed() for the cancellation path.
  /// Clears both the subscription flag and the cached phone so the
  /// header returns to the bare "Subscribe" CTA — and so a subsequent
  /// page load (where `restoreState` reads the phone) doesn't show the
  /// account menu again. Also clears the in-flight OTP reference.
  function markUnsubscribed() {
    localStorage.removeItem(STORAGE_SUB);
    localStorage.removeItem(STORAGE_PHONE);
    sessionStorage.removeItem('pushtiranna_ref');
    sessionStorage.removeItem(STORAGE_PHONE);
    hydrateHeaderButtons();
  }

  function restoreState() {
    // On load, optionally check with server that phone is still subscribed.
    const phone = normalizePhone(localStorage.getItem(STORAGE_PHONE) || '');
    if (phone) {
      // Optimistically mark subscribed, then verify in background
      hydrateHeaderButtons();
      verifySubscriptionWithServer(phone).catch(() => {});
    } else {
      hydrateHeaderButtons();
    }
  }

  async function verifySubscriptionWithServer(phone) {
    try {
      const res = await postForm(ENDPOINTS.checkSubs, { user_mobile: phone });
      const data = await res.json().catch(() => ({}));

      const code    = (data.statusCode || '').toString().toUpperCase();
      const status  = (data.subscriptionStatus || '').toString().toUpperCase();
      const detail  = (data.statusDetail || '').toString();

      // Treat any "not currently subscribed" signal as a confirmation to
      // clear local state — matches the exact PHP wrapper shape you see
      // from Postman:
      //   { isSubscribed: false, statusCode: 'E1951',
      //     statusDetail: 'Format of the address is invalid Or User Already UnRegistered' }
      const isUnreg =
        data.isSubscribed === false ||
        status === 'UNREGISTERED' ||
        /already\s*un[_\s-]?registered/i.test(detail) ||
        /format\s*of\s*the\s*address\s*is\s*invalid/i.test(detail) ||
        code === 'E1951' || code === 'E1351';

      if (isUnreg) {
        // Server says no — clear local state so the header returns to
        // the "Subscribe" CTA and the user-account menu hides.
        localStorage.removeItem(STORAGE_SUB);
        localStorage.removeItem(STORAGE_PHONE);
        hydrateHeaderButtons();
        return;
      }

      if (data && (data.isSubscribed === true || /subscribed|registered/i.test(
        (data.subscriptionStatus || '') + ' ' + (data.statusDetail || '')))) {
        localStorage.setItem(STORAGE_SUB, '1');
        hydrateHeaderButtons();
      }
    } catch (_) {
      // Silent — keep local state, user can re-verify manually
    }
  }

  function showPhone(phone) {
    sessionStorage.setItem(STORAGE_PHONE, phone);
    if (els.displayPhone) {
      els.displayPhone.forEach && els.displayPhone.forEach(() => {}); // noop guard
    }
    $$('[data-display-phone]').forEach(node => {
      node.textContent = DISPLAY_FMT(phone);
    });
  }

  function hydrateHeaderButtons() {
    const subscribed = localStorage.getItem(STORAGE_SUB) === '1';
    const phone = localStorage.getItem(STORAGE_PHONE);
    const validPhone = subscribed && phone && /^01[3-9][0-9]{8}$/.test(phone);

    els.subscribeBtns.forEach(btn => {
      btn.classList.toggle('is-subscribed', subscribed);
      if (validPhone) {
        const last4 = phone.slice(-4);
        btn.textContent = `Subscribed ✓ (${last4})`;
        btn.setAttribute('title', `Subscribed: ${DISPLAY_FMT(phone)}`);
      } else {
        // Restore original Subscribe label
        if (!btn.dataset.originalLabel) {
          btn.dataset.originalLabel = btn.textContent.trim();
        }
        // Preserve "✨ Subscribe — 2.78 BDT/day" if hero/CTA used emoji version
        if (btn.classList.contains('btn-lg') &&
            !btn.dataset.originalLabel.includes('Subscribe')) {
          btn.textContent = '✨ Subscribe — 2.78 BDT/day';
        } else if (btn.dataset.originalLabel) {
          btn.textContent = btn.dataset.originalLabel;
        }
      }
    });

    // Reveal the user-account menu only when there's a verified local
    // subscription. Hidden by default via the HTML `hidden` attribute, so
    // first-paint never flashes it for non-subscribers.
    if (els.userMenu) {
      els.userMenu.hidden = !validPhone;
      els.userMenu.setAttribute('aria-hidden', validPhone ? 'false' : 'true');
    }
    if (validPhone && els.userMenuNumber) {
      const last4 = phone.slice(-4);
      els.userMenuNumber.textContent = `018•••${last4}`;
      if (els.userMenuTrigger) {
        els.userMenuTrigger.setAttribute('title',
          `Account: ${DISPLAY_FMT(phone)} — click to manage`);
      }
    } else if (!validPhone) {
      // Make sure the dropdown itself is closed when the menu is hidden.
      closeUserMenu();
    }
  }

  // ---------- User account menu ----------
  function toggleUserMenu() {
    if (!els.userMenuPanel) return;
    if (els.userMenuPanel.classList.contains('is-open')) {
      closeUserMenu();
    } else {
      openUserMenu();
    }
  }

  function openUserMenu() {
    if (!els.userMenuPanel || !els.userMenuTrigger) return;
    els.userMenuPanel.hidden = false;
    // Force reflow so the transition fires.
    void els.userMenuPanel.offsetWidth;
    els.userMenuPanel.classList.add('is-open');
    els.userMenuTrigger.setAttribute('aria-expanded', 'true');
  }

  function closeUserMenu() {
    if (!els.userMenuPanel || !els.userMenuTrigger) return;
    els.userMenuPanel.classList.remove('is-open');
    els.userMenuTrigger.setAttribute('aria-expanded', 'false');
    // Hide after the transition so screen readers don't see the panel
    // as accessible while it's animating away.
    setTimeout(() => {
      if (els.userMenuPanel && !els.userMenuPanel.classList.contains('is-open')) {
        els.userMenuPanel.hidden = true;
      }
    }, 180);
  }

  /// Log out keeps the user on the landing page but clears the local
  /// subscription marker so the trigger hides and the CTA returns.
  function handleLogout() {
    closeUserMenu();
    localStorage.removeItem(STORAGE_SUB);
    localStorage.removeItem(STORAGE_PHONE);
    sessionStorage.removeItem('pushtiranna_ref');
    sessionStorage.removeItem(STORAGE_PHONE);
    hydrateHeaderButtons();
    showToast('Signed out. You can resubscribe anytime.');
  }

  // ---------- UI helpers ----------
  function showError(node, msg) {
    if (!node) return;
    node.textContent = msg;
    node.hidden = false;
  }

  function clearErrors() {
    els.errorNodes.forEach(n => { n.textContent = ''; n.hidden = true; });
  }

  function clearOtp() {
    els.otpCells.forEach(c => { c.value = ''; c.classList.remove('is-filled'); });
    els.submitButtons.verifyOtp.disabled = true;
    els.otpCells[0]?.focus();
  }

  function setLoading(btn, isLoading) {
    if (!btn) return;
    btn.disabled = isLoading;
    const label = btn.querySelector('.btn-label');
    const spinner = btn.querySelector('.btn-spinner');
    if (label) label.style.opacity = isLoading ? '0.7' : '1';
    if (spinner) spinner.hidden = !isLoading;
  }

  function humanError(code, detail) {
    const table = {
      E1351: 'This number is already registered.',
      E1854: 'Code expired or invalid. Tap Resend.',
      E1951: 'Subscriptions are not available in your region.',
      E1934: 'Rate limit exceeded. Please wait a moment and try again.',
    };
    if (table[code]) return table[code];
    if (detail) return detail;
    if (code) return `Subscription failed (${code}). Please try again.`;
    return 'Subscription failed. Please try again.';
  }

  // ---------- Network ----------
  async function postForm(url, fields) {
    const body = new URLSearchParams();
    Object.entries(fields).forEach(([k, v]) => {
      if (v !== undefined && v !== null) body.append(k, String(v));
    });
    return fetch(url, {
      method: 'POST',
      mode: 'cors',
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json',
      },
      body: body.toString(),
    });
  }
})();
