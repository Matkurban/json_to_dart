import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:json_to_dart/router/router_names.dart';
import 'package:syntax_highlight/syntax_highlight.dart';
import 'package:json_to_dart/config/global/constant.dart';
import 'package:json_to_dart/model/enum/app_language.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:json_to_dart/config/global/app_setting.dart';
import 'package:json_to_dart/model/domain/main/history_item.dart';

class SplashLogic extends GetxController {
  late HighlighterTheme highlighterTheme;

  /// Dart历史记录
  final dartHistory = <HistoryItem>[].obs;

  final javaHistory = <HistoryItem>[].obs;

  ///第一帧构建完以后触发的函数
  @override
  void onReady() async {
    super.onReady();
    await loadThemeFormCache();
    await loadLanguageFormCache();
    await Highlighter.initialize(['dart']);
    highlighterTheme = await HighlighterTheme.loadLightTheme();
    await loadDartHistory();
    await loadJavaHistory();
    Get.offAllNamed(RouterNames.main);
  }

  ///从缓存中加载主题模式，
  Future<void> loadThemeFormCache() async {
    SharedPreferences preferences = Get.find<SharedPreferences>();
    String? themeString = preferences.getString('theme');
    if (themeString != null) {
      ThemeMode themeFormString = themeModeFormString(themeString);
      var appSetting = Get.find<AppSetting>();
      appSetting.theme(themeFormString);
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

  ///从缓存中加载设置的语言
  Future<void> loadLanguageFormCache() async {
    SharedPreferences preferences = Get.find<SharedPreferences>();
    String? language = preferences.getString('language');
    if (language != null) {
      Get.updateLocale(AppLanguage.fromCode(language).locale);
    }
  }

  // 加载历史记录
  Future<void> loadDartHistory() async {
    final prefs = Get.find<SharedPreferences>();
    final historyJson = prefs.getStringList(dartHistoryKey) ?? [];
    // 更新控制器的 history 列表
    dartHistory.assignAll(
      historyJson.map((jsonStr) {
        return HistoryItem.fromJson(jsonDecode(jsonStr));
      }).toList(),
    );
  }

  // 加载历史记录
  Future<void> loadJavaHistory() async {
    final prefs = Get.find<SharedPreferences>();
    final historyJson = prefs.getStringList(javaHistoryKey) ?? [];
    // 更新控制器的 history 列表
    javaHistory.assignAll(
      historyJson.map((jsonStr) {
        return HistoryItem.fromJson(jsonDecode(jsonStr));
      }).toList(),
    );
  }
}
