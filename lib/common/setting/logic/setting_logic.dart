import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:json_to_dart/config/global/app_setting.dart';
import 'package:json_to_dart/widgets/dialog/dialogs.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingLogic extends GetxController {
  ///主题的中文名字
  final RxString themeChineseString = ''.obs;

  ///应用版本
  final RxString version = ''.obs;

  final AppSetting _appSetting = Get.find<AppSetting>();

  @override
  void onInit() {
    super.onInit();
    convert(_appSetting.theme.value);
    ever<ThemeMode>(_appSetting.theme, (mode) => convert(mode));
    getVersion();
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

    void getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version(packageInfo.version);
  }
}
