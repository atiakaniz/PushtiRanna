import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/admin_gate_controller.dart';
import '../controllers/language_controller.dart';
import '../controllers/auth_controller.dart';
import '../routes/app_routes.dart';
import 'package:share_plus/share_plus.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final langController = Get.put(LanguageController());

    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        title: Text('settings'.tr),
        backgroundColor: const Color(0xFF1B5E20),
        foregroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'language'.tr,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 10),

            Obx(() {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.green,
                  ),
                ),
                child: DropdownButton<String>(
                  dropdownColor: const Color(0xFF1E1E1E),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  iconEnabledColor: Colors.green,
                  underline: const SizedBox(),

                  value: langController
                      .currentLocale.value.languageCode,

                  isExpanded: true,

                  items: const [
                    DropdownMenuItem(
                      value: 'en',
                      child: Text(
                        'English',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'bn',
                      child: Text(
                        'বাংলা',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],

                  onChanged: (value) {
                    if (value != null) {
                      langController.changeLanguage(
                        value,
                      );
                    }
                  },
                ),
              );
            }),

            const SizedBox(height: 30),


            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.share),
                label: const Text(
                  "Share App",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  await SharePlus.instance.share(
                    ShareParams(
                      text:
                      "🍲 Check out PushtiRanna - Healthy Bengali Recipe App!\n\n"
                          "Learn more:\n"
                          "https://NestorabyAtia/pushtiranna",
                    ),
                  );
                },

              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.logout),
                label: const Text(
                  "Logout",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(12),
                  ),
                ),

                onPressed: () async {
                  final authController = Get.put(AuthController());

                  await authController.logout();

                  Get.offAllNamed(
                    AppRoutes.GATE,
                  );
                },
              ),
            ),

            // Hidden gesture target for the admin unlock flow. End users
            // will never see a "Manage recipes" entry — only the owner who
            // knows to long-press this label gets the PIN dialog.
            const Spacer(),
            Center(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onLongPress: () => _showAdminUnlock(context),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    'PushtiRanna v1.0.0',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.35),
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showAdminUnlock(BuildContext context) async {
    final gate = Get.find<AdminGateController>();
    final pinCtrl = TextEditingController();

    final ok = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Owner PIN'),
        content: TextField(
          controller: pinCtrl,
          autofocus: true,
          obscureText: true,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: AdminGateController.hasConfiguredPin
                ? 'Enter PIN'
                : 'No PIN configured in this build',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Unlock'),
          ),
        ],
      ),
    );

    if (ok == true) {
      await gate.unlock(pinCtrl.text);
      if (gate.isAdmin.value) {
        Get.offAllNamed(AppRoutes.ADMIN_RECIPES);
      } else {
        Get.snackbar(
          'Wrong PIN',
          'That PIN is not valid for this build.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
    pinCtrl.dispose();
  }
}