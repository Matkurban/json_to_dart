import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSetting extends GetxController {
  ///软件主题
  final Rx<ThemeMode> theme = ThemeMode.system.obs;

  @override
  void onInit() {
    super.onInit();
    loadThemeFormCache();
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
}
