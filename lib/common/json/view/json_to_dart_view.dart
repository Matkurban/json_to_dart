import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:json_to_dart/common/json/logic/json_to_dart_logic.dart';
import 'package:json_to_dart/config/global/constant.dart';
import 'package:json_to_dart/config/theme/app_style.dart';
import 'package:json_to_dart/widgets/dialog/preview_dialog.dart';
import 'package:json_to_dart/widgets/highlight/highlight_text.dart';

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
            builder:
                (context) => IconButton(
                  icon: const Icon(Icons.history),
                  onPressed: () {
                    if (Scaffold.of(context).hasEndDrawer) {
                      Scaffold.of(context).openEndDrawer();
                    }
                  },
                  tooltip: l10n.history,
                ),
          ),
        ],
      ),
      body: _buildBody(context),
      endDrawer: _buildHistoryDrawer(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: AppStyle.defaultPadding,
      child: Column(
        spacing: 10,
        children: [
          // 输入输出分栏
          Expanded(
            child: Row(
              spacing: 10,
              children: [
                _buildInputPanel(context), // 左侧输入区
                _buildOutputPanel(context), // 右侧输出区
              ],
            ),
          ),
          _buildControlPanel(context), // 底部控制区
        ],
      ),
    );
  }

  Widget _buildInputPanel(BuildContext context) {
    return Expanded(
      flex: 5,
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: AppStyle.defaultPadding,
          child: Column(
            spacing: 10,
            children: [
              Row(
                children: [
                  _buildInputLabel(context, l10n.jsonInput),
                  Spacer(),
                  IconButton(
                    onPressed: () => controller.previewJson(context),
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
                  controller: controller.jsonController,
                  minLines: 6,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  style: AppStyle.codeTextStyle,
                  decoration: InputDecoration(hintText: l10n.jsonInputPlaceholder),
                ),
              ),
              _buildClassNameField(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOutputPanel(BuildContext context, {bool showPreviewButton = true}) {
    return Expanded(
      flex: 5,
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: AppStyle.defaultPadding,
          child: Column(
            spacing: 10,
            children: [
              Row(
                children: [
                  _buildInputLabel(context, l10n.dartOutput),
                  Spacer(),
                  if (showPreviewButton)
                    IconButton(
                      onPressed: () {
                        controller.previewDartCode(context, _buildOutputPanel(context, showPreviewButton: false));
                      },
                      icon: Icon(CupertinoIcons.eye),
                      tooltip: l10n.previewDartCode,
                    ),
                  if (!kIsWeb)
                    IconButton(
                      icon: const Icon(Icons.save_alt),
                      onPressed: () => controller.saveToFile(context),
                      tooltip: l10n.saveAsFile,
                    ),
                  IconButton(
                    icon: const Icon(Icons.copy_all),
                    onPressed: () => controller.copy(controller.dartCode.value),
                    tooltip: l10n.copyCode,
                  ),
                ],
              ),
              Expanded(
                child: Obx(() {
                  if (controller.dartCode.isEmpty) {
                    return Center(child: Text(l10n.generateDartHint));
                  }
                  return SingleChildScrollView(
                    child: SizedBox(
                      width: double.infinity,
                      child: HighlightText(codeText: controller.dartCode.value, highlighter: controller.highlighter),
                    ),
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
    return Card(
      margin: EdgeInsets.zero,
      child: Container(
        width: double.infinity,
        padding: AppStyle.defaultPadding,
        child: Column(spacing: 10, children: [_buildOptionsRow(context), _buildActionButtons(context)]),
      ),
    );
  }

  Widget _buildOptionsRow(BuildContext context) {
    return Obx(() {
      return Wrap(
        spacing: 20,
        children: [
          _buildCheckbox(
            context,
            value: controller.nonNullable.value,
            label: l10n.nonNullableFields,
            onChanged: (v) => controller.nonNullable.value = v!,
          ),
          _buildCheckbox(
            context,
            value: controller.generateToJson.value,
            label: l10n.generateToJson,
            onChanged: (v) => controller.generateToJson.value = v!,
          ),
          _buildCheckbox(
            context,
            value: controller.generateFromJson.value,
            label: l10n.generateFromJson,
            onChanged: (v) => controller.generateFromJson.value = v!,
          ),
          _buildCheckbox(
            context,
            value: controller.forceTypeCasting.value,
            label: l10n.forceTypeCasting,
            onChanged: (v) => controller.forceTypeCasting.value = v!,
          ),
        ],
      );
    });
  }

  Widget _buildCheckbox(
    BuildContext context, {
    required bool value,
    required String label,
    required ValueChanged<bool?> onChanged,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(value: value, onChanged: onChanged),
        Text(label, style: Theme.of(context).textTheme.bodyLarge),
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
          icon: const Icon(Icons.format_align_justify),
          label: Text(l10n.formatJson),
          onPressed: controller.formatJson,
          style: FilledButton.styleFrom(backgroundColor: colorScheme.primary),
        ),
        FilledButton.icon(
          icon: const Icon(Icons.create),
          label: Text(l10n.generateDartClass),
          onPressed: controller.generateDartClass,
          style: FilledButton.styleFrom(backgroundColor: colorScheme.secondary),
        ),
        FilledButton.icon(
          icon: const Icon(Icons.add),
          label: Text(l10n.addToHistory),
          onPressed: controller.addHistory,
          style: FilledButton.styleFrom(backgroundColor: colorScheme.primary),
        ),
      ],
    );
  }

  Widget _buildClassNameField(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        Text(l10n.mainClassNameLabel, style: Theme.of(context).textTheme.bodyLarge),
        Expanded(
          child: TextField(
            controller: controller.classNameController,
            style: AppStyle.codeTextStyle,
            decoration: InputDecoration(hintText: l10n.mainClassNamePlaceholder),
          ),
        ),
        IconButton(onPressed: controller.classNameController.clear, icon: const Icon(Icons.clear), tooltip: '清空类名'),
      ],
    );
  }

  Widget _buildInputLabel(BuildContext context, String text) {
    var themeData = Theme.of(context);
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: themeData.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: themeData.colorScheme.primary,
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
                    ? Center(child: Text(l10n.noHistory, style: Theme.of(context).textTheme.bodyLarge))
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
                                  onPressed: () => controller.copy(item.json),
                                  icon: Icon(Icons.copy_all),
                                  tooltip: l10n.copyJson,
                                ),
                                IconButton(
                                  onPressed: () => controller.copy(item.dartCode),
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
