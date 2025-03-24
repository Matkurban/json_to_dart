import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:json_to_dart/config/global/constant.dart';
import 'package:json_to_dart/screens/json/widgets/label_check_box.dart';
import 'package:json_to_dart/screens/json/widgets/model_view_pane.dart';
import 'package:json_to_dart/config/theme/app_style.dart';
import 'package:json_to_dart/screens/json/widgets/title_text.dart';
import 'package:json_to_dart/widgets/dialog/preview_dialog.dart';
import '../logic/json_to_java_logic.dart';

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
        padding: AppStyle.defaultPadding,
        child: Column(
          spacing: 10,
          children: [
            Expanded(child: Row(spacing: 10, children: [_buildInputPanel(context), _buildOutputPanel(context)])),
            _buildControlPanel(context),
          ],
        ),
      ),
      endDrawer: _buildHistoryDrawer(context),
    );
  }

  Widget _buildInputPanel(BuildContext context) {
    return Expanded(
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: AppStyle.defaultPadding,
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  TitleText(text: l10n.jsonInput),
                  Spacer(),
                  IconButton(
                    onPressed: () => previewJson(context, controller.jsonController.text),
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
                  decoration: InputDecoration(hintText: l10n.jsonInputPlaceholder),
                ),
              ),
              Row(
                spacing: 10,
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.classNameController,
                      decoration: InputDecoration(labelText: l10n.mainClassNameLabel),
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
          padding: AppStyle.defaultPadding,
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  TitleText(text: l10n.javaCode),
                  const Spacer(),
                  IconButton(
                    onPressed: () => previewCode(context, controller.javaCode.value),
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
                child: Obx(() => ModelViewPane(code: controller.javaCode.value, highlighter: controller.highlighter)),
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
        padding: AppStyle.defaultPadding,
        child: Column(
          spacing: 10,
          children: [
            Wrap(
              spacing: 20,
              children: [
                Obx(
                  () => LabelCheckBox(
                    label: l10n.useLombok,
                    value: controller.useLombok.value,
                    onChanged: (value) => controller.useLombok.value = value!,
                  ),
                ),
                Obx(
                  () => LabelCheckBox(
                    label: l10n.generateGetterSetter,
                    value: controller.generateGetterSetter.value,
                    onChanged: (value) => controller.generateGetterSetter.value = value!,
                  ),
                ),
                Obx(
                  () => LabelCheckBox(
                    label: l10n.generateBuilder,
                    value: controller.generateBuilder.value,
                    onChanged: (value) => controller.generateBuilder.value = value!,
                  ),
                ),
                Obx(
                  () => LabelCheckBox(
                    label: l10n.generateToString,
                    value: controller.generateToString.value,
                    onChanged: (value) => controller.generateToString.value = value!,
                  ),
                ),
                Obx(
                  () => LabelCheckBox(
                    label: l10n.useOptional,
                    value: controller.useOptional.value,
                    onChanged: (value) => controller.useOptional.value = value!,
                  ),
                ),
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
                  style: FilledButton.styleFrom(backgroundColor: colorScheme.primary),
                ),
                FilledButton.icon(
                  icon: const Icon(Icons.code),
                  label: Text(l10n.generateJavaClass),
                  onPressed: controller.generateJavaClass,
                  style: FilledButton.styleFrom(backgroundColor: colorScheme.secondary),
                ),
                FilledButton.icon(
                  icon: const Icon(Icons.save),
                  label: Text(l10n.addToHistory),
                  onPressed: controller.addToHistory,
                  style: FilledButton.styleFrom(backgroundColor: colorScheme.primary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryDrawer(BuildContext context) {
    var width = MediaQuery.sizeOf(context).width * 0.3;
    return Drawer(width: width, child: _buildHistoryPanel(context));
  }

  Widget _buildHistoryPanel(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Obx(() {
      return Column(
        children: [
          ListTile(
            title: Text('${l10n.history} (${controller.history.length})'),
            trailing: IconButton(
              icon: Icon(Icons.delete_forever_outlined, color: colorScheme.error),
              onPressed: controller.clearHistory,
              tooltip: l10n.clearHistory,
            ),
          ),
          Expanded(
            child:
                controller.history.isEmpty
                    ? Center(
                      child: Text(
                        l10n.noHistory,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    )
                    : ListView.builder(
                      itemCount: controller.history.length,
                      itemBuilder: (context, index) {
                        final item = controller.history[index];
                        return Dismissible(
                          key: ValueKey(item.timestamp),
                          onDismissed: (_) => controller.history.removeAt(index),
                          child: ListTile(
                            title: Text(item.title),
                            subtitle: Text('${item.subtitle} ${formatTimeHHmm(item.timestamp)}'),
                            onTap: () => PreviewDialog.showPreviewDialog(context, item),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () => PreviewDialog.showPreviewDialog(context, item),
                                  icon: Icon(CupertinoIcons.eye, color: colorScheme.primary),
                                  tooltip: l10n.preview,
                                ),
                                IconButton(
                                  onPressed: () => copyToClipboard(item.json),
                                  icon: Icon(Icons.copy_all),
                                  tooltip: l10n.copyJson,
                                ),
                                IconButton(
                                  onPressed: () => copyToClipboard(item.code),
                                  icon: Icon(Icons.code),
                                  tooltip: l10n.copyCode,
                                ),

                                IconButton(
                                  onPressed: () => controller.deleteOne(item),
                                  icon: Icon(Icons.remove, color: colorScheme.error),
                                  tooltip: l10n.delete,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      );
    });
  }
}
