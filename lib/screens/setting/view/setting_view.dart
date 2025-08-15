import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:json_to_dart/config/global/constant.dart';
import 'package:json_to_dart/router/router_names.dart';
import 'package:json_to_dart/screens/setting/logic/setting_logic.dart';

class SettingView extends GetView<SettingLogic> {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(4),
        child: Column(
          children: [
            Card(
              child: ListTile(
                title: Text(l10n.theme),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Obx(() => Text(controller.themeChineseString.value)),
                    Icon(Icons.keyboard_arrow_right),
                  ],
                ),
                onTap: () => Get.toNamed(RouterNames.toggleTheme),
              ),
            ),
            Card(
              child: ListTile(
                title: Text(l10n.language),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Obx(() => Text(controller.languageName.value)),
                    Icon(Icons.keyboard_arrow_right),
                  ],
                ),
                onTap: () => Get.toNamed(RouterNames.toggleLanguage),
              ),
            ),
            Card(
              child: ListTile(
                title: Text(l10n.version),
                trailing: Obx(() => Text(controller.version.value)),
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
