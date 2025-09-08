import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:json_to_dart/config/global/constant.dart';
import 'package:json_to_dart/config/theme/app_style.dart';
import 'package:json_to_dart/screens/json/dart/json_to_dart_logic.dart';
import 'package:json_to_dart/screens/json/widgets/title_text.dart';
import 'package:json_to_dart/utils/message_util.dart';

class JsonInputPanel extends GetWidget<JsonToDartLogic> {
  const JsonInputPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: AppStyle.smallPadding,
        child: Column(
          spacing: 10,
          children: [
            Row(
              children: [
                TitleText(text: l10n.jsonInput),
                Spacer(),
                IconButton(
                  onPressed: () {
                    try{
                      var json = jsonDecode(controller.jsonController.text);
                      previewJson(context, json);
                    } catch (e) {
                        MessageUtil.showWarning(
                        title: l10n.operationPrompt,
                        content: l10n.enterJsonPrompt,
                      );
                    }
                  },
                  icon: Icon(CupertinoIcons.eye),
                  tooltip: l10n.previewJsonView,
                ),
                IconButton(
                  onPressed: () => controller.jsonController.clear(),
                  icon: Icon(Icons.clear),
                  tooltip: l10n.clearInput,
                ),
              ],
            ),
            Expanded(
              child: TextField(
                textInputAction: TextInputAction.newline,
                controller: controller.jsonController,
                expands: true,
                maxLines: null,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(hintText: l10n.jsonInputPlaceholder),
              ),
            ),
            Row(
              spacing: 6,
              children: [
                Expanded(
                  child: TextField(
                    style: AppStyle.codeTextStyle,
                    controller: controller.classNameController,
                    decoration: InputDecoration(labelText: l10n.mainClassNameLabel),
                  ),
                ),
                IconButton(
                  tooltip: '清空类名',
                  icon: const Icon(Icons.clear),
                  onPressed: controller.classNameController.clear,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
