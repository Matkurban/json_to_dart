import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:json_to_dart/config/global/constant.dart';
import 'package:json_to_dart/config/theme/app_style.dart';
import 'package:json_to_dart/screens/json/logic/json_to_dart_logic.dart';
import 'package:json_to_dart/screens/json/widgets/label_check_box.dart';
import 'package:json_to_dart/screens/json/widgets/model_view_pane.dart';
import 'package:json_to_dart/screens/json/widgets/title_text.dart';
import 'package:json_to_dart/widgets/dialog/preview_dialog.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;

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
      body: Padding(
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
      ),
      endDrawer: _buildHistoryDrawer(context),
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
                  TitleText(text: l10n.jsonInput),
                  Spacer(),
                  IconButton(
                    onPressed: () => previewJson(context, controller.jsonController.text),
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
                child: fluent.FluentTheme(
                  data: fluent.FluentThemeData(),
                  child: fluent.TextBox(
                    textInputAction: fluent.TextInputAction.newline,
                    controller: controller.jsonController,
                    expands: true,
                    maxLines: null,
                    placeholder:l10n.jsonInputPlaceholder ,
                    foregroundDecoration: fluent.WidgetStatePropertyAll(
                      fluent.BoxDecoration(border: Border.fromBorderSide(BorderSide.none)),
                    ),
                  ),
                ),
              ),
              _buildClassNameField(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOutputPanel(BuildContext context) {
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
                  TitleText(text: l10n.dartOutput),
                  Spacer(),
                  IconButton(
                    onPressed: () => previewCode(context, controller.dartCode.value),
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
                child: Obx(
                  () => ModelViewPane(
                    code: controller.dartCode.value,
                    highlighter: controller.highlighter,
                  ),
                ),
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
        child: Column(
          spacing: 10,
          children: [_buildOptionsRow(context), _buildActionButtons(context)],
        ),
      ),
    );
  }

  Widget _buildOptionsRow(BuildContext context) {
    return Wrap(
      spacing: 20,
      children: [
        Obx(
          () => LabelCheckBox(
            value: controller.nonNullable.value,
            label: l10n.nonNullableFields,
            onChanged: (v) => controller.nonNullable.value = v!,
          ),
        ),
        Obx(
          () => LabelCheckBox(
            value: controller.generateToJson.value,
            label: l10n.generateToJson,
            onChanged: (v) => controller.generateToJson.value = v!,
          ),
        ),
        Obx(
          () => LabelCheckBox(
            value: controller.generateFromJson.value,
            label: l10n.generateFromJson,
            onChanged: (v) => controller.generateFromJson.value = v!,
          ),
        ),
        Obx(
          () => LabelCheckBox(
            value: controller.forceTypeCasting.value,
            label: l10n.forceTypeCasting,
            onChanged: (v) => controller.forceTypeCasting.value = v!,
          ),
        ),
        Obx(
          () => LabelCheckBox(
            value: controller.generateCopyWith.value,
            label: l10n.generateCopyWith,
            onChanged: (v) => controller.generateCopyWith.value = v!,
          ),
        ),
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
      spacing: 10,
      children: [
        Expanded(
          child: TextField(
            controller: controller.classNameController,
            style: AppStyle.codeTextStyle,
            decoration: InputDecoration(labelText: l10n.mainClassNameLabel),
          ),
        ),
        IconButton(
          onPressed: controller.classNameController.clear,
          icon: const Icon(Icons.clear),
          tooltip: '清空类名',
        ),
      ],
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
                      child: Text(l10n.noHistory, style: Theme.of(context).textTheme.bodyLarge),
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
