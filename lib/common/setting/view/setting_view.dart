import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:json_to_dart/common/setting/logic/setting_logic.dart';

class SettingView extends GetView<SettingLogic> {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('设置')),
      body: ListView(
        children: [
          ListTile(
            title: Text('主题'),
            onTap: () => controller.selectTheme(context),
          ),
          ListTile(title: Text('版本')),
        ],
      ),
    );
  }
}
