import 'package:get/get.dart';
import 'package:flutter/material.dart';

class LanguageController extends GetxController {
  var currentLocale = const Locale('en', 'US').obs;

  void changeLanguage(String langCode) {
    if (langCode == 'bn') {
      Get.updateLocale(const Locale('bn', 'BD'));
      currentLocale.value = const Locale('bn', 'BD');
    } else {
      Get.updateLocale(const Locale('en', 'US'));
      currentLocale.value = const Locale('en', 'US');
    }
  }
}