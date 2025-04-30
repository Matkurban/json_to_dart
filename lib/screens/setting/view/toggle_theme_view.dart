import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:json_to_dart/config/global/constant.dart';
import 'package:json_to_dart/config/theme/app_style.dart';
import 'package:json_to_dart/config/global/app_setting.dart';

class ToggleThemeView extends GetView<AppSetting> {
  const ToggleThemeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(l10n.selectTheme)),
      body: ListView(
        padding: AppStyle.defaultPadding,
        children: [
          Obx(() {
            return RadioListTile<ThemeMode>(
              value: ThemeMode.light,
              groupValue: controller.theme.value,
              onChanged: (value) => controller.changeTheme(value!),
              title: Text(l10n.lightTheme),
              selected: ThemeMode.light == controller.theme.value,
            );
          }),
          Obx(() {
            return RadioListTile<ThemeMode>(
              value: ThemeMode.dark,
              groupValue: controller.theme.value,
              onChanged: (value) => controller.changeTheme(value!),
              title: Text(l10n.darkTheme),
              selected: ThemeMode.dark == controller.theme.value,
            );
          }),
          Obx(() {
            return RadioListTile<ThemeMode>(
              value: ThemeMode.system,
              groupValue: controller.theme.value,
              onChanged: (value) => controller.changeTheme(value!),
              title: Text(l10n.systemTheme),
              selected: ThemeMode.system == controller.theme.value,
            );
          }),
        ],
      ),
    );
  }
}
