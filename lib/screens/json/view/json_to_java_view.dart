import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:json_to_dart/config/global/constant.dart';
import 'package:json_to_dart/screens/json/widgets/label_check_box.dart';
import 'package:json_to_dart/screens/json/widgets/model_view_pane.dart';
import 'package:json_to_dart/config/theme/app_style.dart';
import 'package:json_to_dart/widgets/dialog/preview_dialog.dart';
import '../logic/json_to_java_logic.dart';

class JsonToJavaView extends GetView<JsonToJavaLogic> {
  const JsonToJavaView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JSON to Java Converter'),
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
                tooltip: 'History',
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
            Expanded(
              child: Row(
                spacing: 10,
                children: [_buildInputPanel(context), _buildOutputPanel(context)],
              ),
            ),
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
              const Text('JSON Input'),
              Expanded(
                child: TextField(
                  controller: controller.jsonController,
                  expands: true,
                  maxLines: null,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(hintText: 'Enter JSON here'),
                ),
              ),
              Row(
                spacing: 10,
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.classNameController,
                      decoration: const InputDecoration(labelText: 'Class Name'),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: controller.packageNameController,
                      decoration: const InputDecoration(labelText: 'Package Name (Optional)'),
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
                  const Text('Java Code'),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.copy),
                    onPressed: () => copyToClipboard(controller.javaCode.value),
                    tooltip: 'Copy Code',
                  ),
                ],
              ),
              Expanded(
                child: Obx(
                  () => ModelViewPane(
                    code: controller.javaCode.value,
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
                    label: 'Use Lombok',
                    value: controller.useLombok.value,
                    onChanged: (value) => controller.useLombok.value = value!,
                  ),
                ),
                Obx(
                  () => LabelCheckBox(
                    label: 'Generate Getter/Setter',
                    value: controller.generateGetterSetter.value,
                    onChanged: (value) => controller.generateGetterSetter.value = value!,
                  ),
                ),
                Obx(
                  () => LabelCheckBox(
                    label: 'Generate Builder',
                    value: controller.generateBuilder.value,
                    onChanged: (value) => controller.generateBuilder.value = value!,
                  ),
                ),
                Obx(
                  () => LabelCheckBox(
                    label: 'Generate ToString',
                    value: controller.generateToString.value,
                    onChanged: (value) => controller.generateToString.value = value!,
                  ),
                ),
                Obx(
                  () => LabelCheckBox(
                    label: 'Use Optional',
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
                  label: const Text('Format JSON'),
                  onPressed: controller.formatJson,
                  style: FilledButton.styleFrom(backgroundColor: colorScheme.primary),
                ),
                FilledButton.icon(
                  icon: const Icon(Icons.code),
                  label: const Text('Generate Java Class'),
                  onPressed: controller.generateJavaClass,
                  style: FilledButton.styleFrom(backgroundColor: colorScheme.secondary),
                ),
                FilledButton.icon(
                  icon: const Icon(Icons.save),
                  label: const Text('Save to History'),
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
