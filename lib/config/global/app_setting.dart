import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:json_to_dart/model/enum/app_language.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSetting extends GetxController {
  ///软件主题
  final Rx<ThemeMode> theme = ThemeMode.system.obs;

  ///系统语言
  final Rx<AppLanguage> language = AppLanguage.chineseSimplified.obs;

  @override
  void onInit() {
    super.onInit();
    loadThemeFormCache();
    loadLanguageFormCache();
  }

  ///更改主题方法
  void changeTheme(ThemeMode themeMode) {
    theme(themeMode);
    Get.changeThemeMode(themeMode);
    var preferences = Get.find<SharedPreferences>();
    preferences.setString('theme', themeMode.name);
  }

  ///从缓存中加载主题模式，
  void loadThemeFormCache() {
    SharedPreferences preferences = Get.find<SharedPreferences>();
    String? themeString = preferences.getString('theme');
    if (themeString != null) {
      ThemeMode themeFormString = themeModeFormString(themeString);
      theme(themeFormString);
      Get.changeThemeMode(themeFormString);
    }
  }

  ///把字符串类型的主题模式转换为枚举对象
  ThemeMode themeModeFormString(String modeString) {
    switch (modeString) {
      case 'system':
        return ThemeMode.system;
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  ///更改语言
  void changeLanguage(AppLanguage languages) async {
    language(languages);
    await Get.updateLocale(languages.locale);
    var preferences = Get.find<SharedPreferences>();
    preferences.setString('language', languages.code);
  }

  ///从缓存中加载设置的语言
  void loadLanguageFormCache() {
    SharedPreferences preferences = Get.find<SharedPreferences>();
    String? language = preferences.getString('language');
    if (language != null) {
      Get.updateLocale(AppLanguage.fromCode(language).locale);
    }
  }
}
