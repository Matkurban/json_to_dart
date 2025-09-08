import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:json_to_dart/config/global/constant.dart';
import 'package:json_to_dart/config/theme/app_style.dart';
import 'package:json_to_dart/model/enum/app_language.dart';
import 'package:json_to_dart/config/global/app_setting.dart';

class ToggleLanguageView extends GetView<AppSetting> {
  const ToggleLanguageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(l10n.selectLanguage)),
      body: RadioGroup(
        groupValue: controller.language.value,
        onChanged: (value) => controller.changeLanguage(value!),
        child: ListView.builder(
          padding: AppStyle.defaultPadding,
          itemBuilder: (context, index) {
            var values = AppLanguage.values;
           return RadioListTile(
              value: values[index],
              title: Text(values[index].displayName),
              selected: values[index] == controller.language.value,
              toggleable: true,
            );
          },
          itemCount: AppLanguage.values.length,
        ),
      ),
    );
  }
}
