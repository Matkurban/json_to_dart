import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_to_dart/config/global/constant.dart';
import 'package:json_to_dart/config/theme/app_style.dart';
import 'package:json_to_dart/screens/json/generator/widgets/resizable_panels.dart';
import 'package:json_to_dart/screens/json/widgets/title_text.dart';
import 'package:json_to_dart/screens/json/widgets/label_check_box.dart';
import 'package:json_to_dart/screens/json/widgets/model_view_pane.dart';
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
          children: [
            // 输入输出分栏
            Expanded(
              child: ResizablePanels(
                minWidth: 240,
                child1: _buildInputPanel(context),
                child2: _buildOutputPanel(context),
              ),
            ),
            Divider(height: 3),
            _buildControlPanel(context), // 底部控制区
          ],
        ),
      ),
      endDrawer: const JsonToDartDrawer(),
    );
  }

  Widget _buildInputPanel(BuildContext context) {
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
                    previewJson(context, controller.jsonController.text);
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
                decoration: InputDecoration(
                  hintText: l10n.jsonInputPlaceholder,
                ),
              ),
            ),
            _buildClassNameField(context),
          ],
        ),
      ),
    );
  }

  Widget _buildOutputPanel(BuildContext context) {
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

  Widget _buildControlPanel(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Container(
        width: double.infinity,
        padding: AppStyle.smallPadding,
        child: Column(
          children: [_buildOptionsRow(context), _buildActionButtons(context)],
        ),
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

  Widget _buildClassNameField(BuildContext context) {
    return Row(
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
    );
  }
}
