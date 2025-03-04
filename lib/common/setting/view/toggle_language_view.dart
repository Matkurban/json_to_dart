import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:json_to_dart/config/global/app_setting.dart';
import 'package:json_to_dart/config/global/constant.dart';
import 'package:json_to_dart/config/theme/app_style.dart';
import 'package:json_to_dart/model/enum/app_language.dart';

class ToggleLanguageView extends GetView<AppSetting> {
  const ToggleLanguageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(l10n.selectLanguage)),
      body: ListView.builder(
        padding: AppStyle.defaultPadding,
        itemBuilder: (context, index) {
          var values = AppLanguage.values;
          return Obx(() {
            return RadioListTile(
              value: values[index],
              groupValue: controller.language.value,
              onChanged: (value) => controller.changeLanguage(value!),
              title: Text(values[index].displayName),
              selected: values[index]==controller.language.value,
            );
          });
        },
        itemCount: AppLanguage.values.length,
      ),
    );
  }
}
