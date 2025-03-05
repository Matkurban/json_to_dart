import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:json_to_dart/model/enum/app_language.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSetting extends GetxController {
  ///软件主题
  final Rx<ThemeMode> theme = ThemeMode.system.obs;

  ///系统语言
  final Rx<AppLanguage> language = AppLanguage.chineseSimplified.obs;

  ///更改主题方法
  void changeTheme(ThemeMode themeMode) {
    theme(themeMode);
    Get.changeThemeMode(themeMode);
    var preferences = Get.find<SharedPreferences>();
    preferences.setString('theme', themeMode.name);
  }

  ///更改语言
  void changeLanguage(AppLanguage languages) async {
    language(languages);
    await Get.updateLocale(languages.locale);
    var preferences = Get.find<SharedPreferences>();
    preferences.setString('language', languages.code);
  }
}
