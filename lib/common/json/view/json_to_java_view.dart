import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:json_to_dart/common/json/widgets/model_view_pane.dart';
import 'package:json_to_dart/config/theme/app_style.dart';
import 'package:json_to_dart/model/domain/dart/history_item.dart';
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
                  Scaffold.of(context).openEndDrawer();
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
        child: Padding(
          padding: AppStyle.defaultPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('Java Code'),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.copy),
                    onPressed: () => controller.copy(controller.javaCode.value),
                    tooltip: 'Copy Code',
                  ),
                ],
              ),
              const SizedBox(height: 8),
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
      child: Container(
        width: double.infinity,
        padding: AppStyle.defaultPadding,
        child: Column(
          spacing: 10,
          children: [
            Obx(
              () => Wrap(
                spacing: 16,
                runSpacing: 8,
                children: [
                  _buildCheckbox(
                    'Use Lombok',
                    controller.useLombok.value,
                    (value) => controller.useLombok.value = value!,
                  ),
                  _buildCheckbox(
                    'Generate Getter/Setter',
                    controller.generateGetterSetter.value,
                    (value) => controller.generateGetterSetter.value = value!,
                  ),
                  _buildCheckbox(
                    'Generate Builder',
                    controller.generateBuilder.value,
                    (value) => controller.generateBuilder.value = value!,
                  ),
                  _buildCheckbox(
                    'Generate ToString',
                    controller.generateToString.value,
                    (value) => controller.generateToString.value = value!,
                  ),
                  _buildCheckbox(
                    'Use Optional',
                    controller.useOptional.value,
                    (value) => controller.useOptional.value = value!,
                  ),
                ],
              ),
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

  Widget _buildCheckbox(String label, bool value, ValueChanged<bool?> onChanged) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [Checkbox(value: value, onChanged: onChanged), Text(label)],
    );
  }

  Widget _buildHistoryDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const DrawerHeader(child: Text('Conversion History', style: TextStyle(fontSize: 24))),
          Expanded(
            child: Obx(
              () =>
                  controller.history.isEmpty
                      ? const Center(child: Text('No history yet'))
                      : ListView.builder(
                        itemCount: controller.history.length,
                        itemBuilder: (context, index) {
                          final item = controller.history[index];
                          return Dismissible(
                            key: ValueKey(item.timestamp),
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 16),
                              child: const Icon(Icons.delete, color: Colors.white),
                            ),
                            onDismissed: (_) => controller.removeHistoryItem(index),
                            child: ListTile(
                              title: Text(item.title),
                              subtitle: Text(item.subtitle),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.copy),
                                    onPressed: () => controller.copy(item.dartCode),
                                    tooltip: 'Copy Java Code',
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.content_copy),
                                    onPressed: () => controller.copy(item.json),
                                    tooltip: 'Copy JSON',
                                  ),
                                ],
                              ),
                              onTap: () => _showHistoryItemPreview(context, item),
                            ),
                          );
                        },
                      ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.delete_forever),
              label: const Text('Clear History'),
              onPressed: controller.clearHistory,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showHistoryItemPreview(BuildContext context, HistoryItem item) {
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.8,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(item.title, style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 16),
                  Expanded(
                    child: DefaultTabController(
                      length: 2,
                      child: Column(
                        children: [
                          const TabBar(tabs: [Tab(text: 'JSON'), Tab(text: 'Java Code')]),
                          Expanded(
                            child: TabBarView(
                              children: [
                                SingleChildScrollView(
                                  child: Text(
                                    item.json,
                                    style: const TextStyle(fontFamily: 'monospace'),
                                  ),
                                ),
                                SingleChildScrollView(
                                  child: Text(
                                    item.dartCode,
                                    style: const TextStyle(fontFamily: 'monospace'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  OverflowBar(
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Close'),
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.copy),
                        label: const Text('Copy Java Code'),
                        onPressed: () => controller.copy(item.dartCode),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
