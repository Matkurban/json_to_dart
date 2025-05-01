import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_to_dart/config/global/constant.dart';
import 'package:json_to_dart/config/theme/app_style.dart';
import 'package:json_to_dart/screens/json/widgets/title_text.dart';
import 'package:json_to_dart/screens/json/widgets/label_check_box.dart';
import 'package:json_to_dart/screens/json/widgets/model_view_pane.dart';
import 'package:json_to_dart/screens/json/java/json_to_java_logic.dart';
import 'package:json_to_dart/screens/json/java/widgets/json_to_java_drawer.dart';

class JsonToJavaView extends GetView<JsonToJavaLogic> {
  const JsonToJavaView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.jsonToJava),
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
            Expanded(
              child: Row(
                children: [
                  _buildInputPanel(context),
                  VerticalDivider(width: 3),
                  _buildOutputPanel(context),
                ],
              ),
            ),
            Divider(height: 3),
            _buildControlPanel(context),
          ],
        ),
      ),
      endDrawer: const JsonToJavaDrawer(),
    );
  }

  Widget _buildInputPanel(BuildContext context) {
    return Expanded(
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: AppStyle.smallPadding,
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    onPressed: controller.jsonController.clear,
                    icon: Icon(Icons.clear),
                    tooltip: l10n.clearInput,
                  ),
                ],
              ),
              Expanded(
                child: TextField(
                  controller: controller.jsonController,
                  textInputAction: TextInputAction.newline,
                  expands: true,
                  maxLines: null,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: InputDecoration(
                    hintText: l10n.jsonInputPlaceholder,
                  ),
                ),
              ),
              Row(
                spacing: 6,
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.classNameController,
                      decoration: InputDecoration(
                        labelText: l10n.mainClassNameLabel,
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: controller.packageNameController,
                      decoration: InputDecoration(labelText: l10n.packageName),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOutputPanel(BuildContext context) {
    return Expanded(
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: AppStyle.smallPadding,
          child: Column(
            children: [
              Row(
                children: [
                  TitleText(text: l10n.javaCode),
                  const Spacer(),
                  IconButton(
                    onPressed:
                        () => previewCode(context, controller.javaCode.value),
                    icon: Icon(CupertinoIcons.eye),
                    tooltip: l10n.previewCode,
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy),
                    onPressed: () => copyToClipboard(controller.javaCode.value),
                    tooltip: l10n.copyCode,
                  ),
                ],
              ),
              Expanded(
                child: Obx(() {
                  return ModelViewPane(
                    code: controller.javaCode.value,
                    highlighter: controller.highlighter,
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControlPanel(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Card(
      margin: EdgeInsets.zero,
      child: Container(
        width: double.infinity,
        padding: AppStyle.smallPadding,
        child: Column(
          children: [
            Wrap(
              spacing: 10,
              children: [
                Obx(() {
                  return LabelCheckBox(
                    label: l10n.useLombok,
                    value: controller.useLombok.value,
                    onChanged: (value) => controller.useLombok.value = value!,
                  );
                }),
                Obx(() {
                  return LabelCheckBox(
                    label: l10n.generateGetterSetter,
                    value: controller.generateGetterSetter.value,
                    onChanged:
                        (value) =>
                            controller.generateGetterSetter.value = value!,
                  );
                }),
                Obx(() {
                  return LabelCheckBox(
                    label: l10n.generateBuilder,
                    value: controller.generateBuilder.value,
                    onChanged:
                        (value) => controller.generateBuilder.value = value!,
                  );
                }),
                Obx(() {
                  return LabelCheckBox(
                    label: l10n.generateToString,
                    value: controller.generateToString.value,
                    onChanged:
                        (value) => controller.generateToString.value = value!,
                  );
                }),
                Obx(() {
                  return LabelCheckBox(
                    label: l10n.useOptional,
                    value: controller.useOptional.value,
                    onChanged: (value) => controller.useOptional.value = value!,
                  );
                }),
              ],
            ),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: [
                FilledButton.icon(
                  icon: const Icon(Icons.format_align_left),
                  label: Text(l10n.formatJson),
                  onPressed: controller.formatJson,
                  style: FilledButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                  ),
                ),
                FilledButton.icon(
                  icon: const Icon(Icons.code),
                  label: Text(l10n.generateJavaClass),
                  onPressed: controller.generateJavaClass,
                  style: FilledButton.styleFrom(
                    backgroundColor: colorScheme.secondary,
                  ),
                ),
                FilledButton.icon(
                  icon: const Icon(Icons.save),
                  label: Text(l10n.addToHistory),
                  onPressed: controller.addToHistory,
                  style: FilledButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
