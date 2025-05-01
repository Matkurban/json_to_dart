import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:json_to_dart/config/global/constant.dart';
import 'package:json_to_dart/config/theme/app_style.dart';
import 'package:json_to_dart/screens/json/generator/json_generator_logic.dart';
import 'package:json_to_dart/screens/json/widgets/model_view_pane.dart';
import 'package:json_to_dart/screens/json/widgets/title_text.dart';

class GeneratorOutputPanel extends GetWidget<JsonGeneratorLogic> {
  const GeneratorOutputPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: AppStyle.smallPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                TitleText(text: l10n.jsonOutput),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    previewJson(context, controller.jsonOutput.value);
                  },
                  icon: const Icon(Icons.visibility),
                  tooltip: l10n.previewJsonView,
                ),
                IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: () {
                    copyToClipboard(controller.jsonOutput.value);
                  },
                  tooltip: l10n.copyJson,
                ),
                IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: () => _showSaveDialog(context),
                  tooltip: l10n.saveToHistory,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Obx(() {
                return ModelViewPane(
                  code: controller.jsonOutput.value,
                  highlighter: controller.highlighter,
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void _showSaveDialog(BuildContext context) {
    final nameController = TextEditingController();
    Get.dialog(
      AlertDialog(
        title: Text(l10n.saveToHistory),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: l10n.name,
            hintText: l10n.enterName,
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text(l10n.cancel)),
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                controller.addToHistory(nameController.text);
                Get.back();
              }
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }
}
