import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:json_to_dart/widgets/dialog/dialogs.dart';

class SettingLogic extends GetxController {
  ///选择主题
  void selectTheme(BuildContext context) {
    Dialogs.selectThemeDialog(context);
  }
}
