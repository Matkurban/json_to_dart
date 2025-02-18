import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:json_to_dart/config/global/app_setting.dart';

sealed class Dialogs {
  static void selectThemeDialog(BuildContext context) {
    AppSetting appSetting = Get.find<AppSetting>();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('选择主题'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Obx(() {
                return RadioListTile<ThemeMode>(
                  value: ThemeMode.light,
                  groupValue: appSetting.theme.value,
                  onChanged: (value) {
                    Get.back();
                    appSetting.changeTheme(value!);
                  },
                  title: Text('亮色'),
                );
              }),
              Obx(() {
                return RadioListTile<ThemeMode>(
                  value: ThemeMode.dark,
                  groupValue: appSetting.theme.value,
                  onChanged: (value) {
                    Get.back();
                    appSetting.changeTheme(value!);
                  },
                  title: Text('暗色'),
                );
              }),
              Obx(() {
                return RadioListTile<ThemeMode>(
                  value: ThemeMode.system,
                  groupValue: appSetting.theme.value,
                  onChanged: (value) {
                    Get.back();
                    appSetting.changeTheme(value!);
                  },
                  title: Text('系统'),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
