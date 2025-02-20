import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:json_to_dart/common/setting/logic/setting_logic.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingView extends GetView<SettingLogic> {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('设置')),
      body: ListView(
        children: [
          Card(
            child: ListTile(
              title: Text('主题'),
              trailing: Obx(() => Text(controller.themeChineseString.value)),
              onTap: () => controller.selectTheme(context),
            ),
          ),
          Card(
            child: ListTile(title: Text('版本'), trailing: Obx(() => Text(controller.version.value))),
          ),
          Card(
            child: ListTile(
              title: Text('官网'),
              trailing: Icon(CupertinoIcons.arrow_up_right),
              onTap: () => launchUrl(Uri.parse('https://jsontodart.cn')),
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Github仓库'),
              trailing: Icon(CupertinoIcons.arrow_up_right),
              onTap: () => launchUrl(Uri.parse('https://github.com/Matkurban/json_to_dart')),
            ),
          ),
        ],
      ),
    );
  }
}
