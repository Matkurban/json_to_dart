import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:json_to_dart/config/global/constant.dart';
import 'package:json_to_dart/config/theme/app_style.dart';
import 'package:json_to_dart/screens/json/dart/json_to_dart_logic.dart';
import 'package:json_to_dart/screens/json/widgets/model_view_pane.dart';
import 'package:json_to_dart/screens/json/widgets/title_text.dart';

class DartOutputPanel extends GetWidget<JsonToDartLogic> {
  const DartOutputPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: AppStyle.smallPadding,
        child: Column(
          children: [
            Row(
              children: [
                TitleText(text: l10n.dartOutput),
                Spacer(),
                IconButton(
                  onPressed: () {
                    previewCode(context, controller.dartCode.value);
                  },
                  icon: Icon(CupertinoIcons.eye),
                  tooltip: l10n.previewCode,
                ),
                IconButton(
                  icon: const Icon(Icons.copy_all),
                  onPressed: () => copyToClipboard(controller.dartCode.value),
                  tooltip: l10n.copyCode,
                ),
              ],
            ),
            Expanded(
              child: Obx(() {
                return ModelViewPane(
                  code: controller.dartCode.value,
                  highlighter: controller.highlighter,
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
