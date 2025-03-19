import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:json_to_dart/screens/setting/logic/setting_logic.dart';
import 'package:json_to_dart/config/global/constant.dart';
import 'package:json_to_dart/config/theme/app_style.dart';
import 'package:json_to_dart/router/router_names.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingView extends GetView<SettingLogic> {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        padding: AppStyle.defaultPadding,
        children: [
          Card(
            child: ListTile(
              title: Text(l10n.theme),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [Obx(() => Text(controller.themeChineseString.value)), Icon(Icons.keyboard_arrow_right)],
              ),
              onTap: () => Get.toNamed(RouterNames.toggleTheme),
            ),
          ),
          Card(
            child: ListTile(
              title: Text(l10n.language),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [Obx(() => Text(controller.languageName.value)), Icon(Icons.keyboard_arrow_right)],
              ),
              onTap: () => Get.toNamed(RouterNames.toggleLanguage),
            ),
          ),
          Card(
            child: ListTile(
              title: Text(AppLocalizations.of(context)!.flutterMobileMirrorConfig),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () => Get.toNamed(RouterNames.flutterMobile),
            ),
          ),

          Card(
            child: ListTile(
              title: Text(AppLocalizations.of(context)!.androidStudioDartTemplate),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () => Get.toNamed(RouterNames.studioTemplate),
            ),
          ),
          Card(
            child: ListTile(
              title: Text(l10n.officialWebsite),
              trailing: Icon(CupertinoIcons.arrow_up_right),
              onTap: () => launchUrl(Uri.parse('https://jsontodart.cn')),
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
    );
  }
}
