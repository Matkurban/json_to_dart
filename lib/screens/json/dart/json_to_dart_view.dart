import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:json_to_dart/config/global/constant.dart';
import 'package:json_to_dart/config/theme/app_style.dart';
import 'package:json_to_dart/screens/json/dart/widgets/dart_output_panel.dart';
import 'package:json_to_dart/screens/json/dart/widgets/json_input_panel.dart';
import 'package:json_to_dart/screens/json/widgets/label_check_box.dart';
import 'package:json_to_dart/screens/json/dart/json_to_dart_logic.dart';
import 'package:json_to_dart/screens/json/dart/widgets/json_to_dart_drawer.dart';

class JsonToDartView extends GetView<JsonToDartLogic> {
  const JsonToDartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.jsonToDartTool),
        centerTitle: true,
        actions: [
          Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.history),
                onPressed: () {
                  if (Scaffold.of(context).hasEndDrawer) {
                    Scaffold.of(context).openEndDrawer();
                  }
                },
                tooltip: l10n.history,
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: AppStyle.smallPadding,
        child: Column(
          spacing: 10,
          children: [
            Expanded(
              child: Row(
                spacing: 10,
                children: [
                  Expanded(child: JsonInputPanel()),
                  Expanded(child: DartOutputPanel()),
                ],
              ),
            ),
            _buildControlPanel(context),
          ],
        ),
      ),

      endDrawer: const JsonToDartDrawer(),
    );
  }

  Widget _buildControlPanel(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Container(
        width: double.infinity,
        padding: AppStyle.smallPadding,
        child: Column(children: [_buildOptionsRow(context), _buildActionButtons(context)]),
      ),
    );
  }

  Widget _buildOptionsRow(BuildContext context) {
    return Wrap(
      spacing: 10,
      children: [
        Obx(() {
          return LabelCheckBox(
            value: controller.nonNullable.value,
            label: l10n.nonNullableFields,
            onChanged: (v) => controller.nonNullable.value = v!,
          );
        }),
        Obx(() {
          return LabelCheckBox(
            value: controller.generateToJson.value,
            label: l10n.generateToJson,
            onChanged: (v) => controller.generateToJson.value = v!,
          );
        }),
        Obx(() {
          return LabelCheckBox(
            value: controller.generateFromJson.value,
            label: l10n.generateFromJson,
            onChanged: (v) => controller.generateFromJson.value = v!,
          );
        }),
        Obx(() {
          return LabelCheckBox(
            value: controller.forceTypeCasting.value,
            label: l10n.forceTypeCasting,
            onChanged: (v) => controller.forceTypeCasting.value = v!,
          );
        }),
        Obx(() {
          return LabelCheckBox(
            value: controller.generateCopyWith.value,
            label: l10n.generateCopyWith,
            onChanged: (v) => controller.generateCopyWith.value = v!,
          );
        }),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      alignment: WrapAlignment.center,
      children: [
        FilledButton.icon(
          icon: const Icon(Icons.format_align_left),
          label: Text(l10n.formatJson),
          onPressed: controller.formatJson,
          style: FilledButton.styleFrom(backgroundColor: colorScheme.primary),
        ),
        FilledButton.icon(
          icon: const Icon(Icons.code),
          label: Text(l10n.generateDartClass),
          onPressed: controller.generateDartClass,
          style: FilledButton.styleFrom(backgroundColor: colorScheme.secondary),
        ),
        FilledButton.icon(
          icon: const Icon(Icons.save),
          label: Text(l10n.addToHistory),
          onPressed: controller.addHistory,
          style: FilledButton.styleFrom(backgroundColor: colorScheme.primary),
        ),
      ],
    );
  }
}
