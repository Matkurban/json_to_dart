import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:json_to_dart/config/global/app_setting.dart';
import 'package:json_to_dart/widgets/dialog/dialogs.dart';

class SettingLogic extends GetxController {
  ///主题的中文名字
  final RxString themeChineseString = ''.obs;

  final AppSetting _appSetting = Get.find<AppSetting>();

  @override
  void onInit() {
    super.onInit();
    convert(_appSetting.theme.value);
    ever<ThemeMode>(_appSetting.theme, (mode) => convert(mode));
  }

  void convert(ThemeMode mode) => themeChineseString(themeConvertToString(mode));

  ///选择主题
  void selectTheme(BuildContext context) {
    Dialogs.selectThemeDialog(context);
  }

  ///主题转换为中文字符串
  String themeConvertToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return '系统';
      case ThemeMode.light:
        return '亮色';
      case ThemeMode.dark:
        return '暗色';
    }
  }
}
