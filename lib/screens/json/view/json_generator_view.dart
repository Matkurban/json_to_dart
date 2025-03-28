import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:json_to_dart/config/global/constant.dart';
import 'package:json_to_dart/config/theme/app_style.dart';
import 'package:json_to_dart/screens/json/logic/json_generator_logic.dart';
import 'package:json_to_dart/screens/json/widgets/model_view_pane.dart';
import 'package:json_to_dart/screens/json/widgets/title_text.dart';

class JsonGeneratorView extends GetView<JsonGeneratorLogic> {
  const JsonGeneratorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.jsonGenerator),
        centerTitle: true,
        actions: [
          Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.history),
                onPressed: () => Scaffold.of(context).openEndDrawer(),
                tooltip: l10n.history,
              );
            }
          ),
        ],
      ),
      endDrawer: _buildDrawer(context),
      body: Padding(
        padding: AppStyle.defaultPadding,
        child: Row(
          spacing: 10,
          children: [
            Expanded(flex: 1, child: _buildOutputPanel(context)),
            Expanded(flex: 1, child: _buildInputPanel(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            child: Center(
              child: Text(
                l10n.history,
                style: const TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
          ),
          Expanded(
            child: Obx(
              () => ListView.builder(
                itemCount: controller.histories.length,
                itemBuilder: (context, index) {
                  final history = controller.histories[index];
                  return ListTile(
                    title: Text(history.name),
                    subtitle: Text(
                      '${history.createTime.year}-${history.createTime.month}-${history.createTime.day} ${history.createTime.hour}:${history.createTime.minute}',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => controller.deleteHistory(history),
                    ),
                    onTap: () {
                      controller.loadFromHistory(history);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOutputPanel(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: AppStyle.defaultPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                TitleText(text: l10n.jsonOutput),
                const Spacer(),
                IconButton(
                  onPressed: () => previewJson(context, controller.jsonOutput.value),
                  icon: const Icon(Icons.visibility),
                  tooltip: l10n.previewJsonView,
                ),
                IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: () => controller.copyToClipboard(controller.jsonOutput.value),
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
              child: Obx(() => ModelViewPane(code: controller.jsonOutput.value, highlighter: controller.highlighter)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputPanel(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: AppStyle.defaultPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                TitleText(text: l10n.jsonFields),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: controller.addField,
                  tooltip: l10n.addField,
                ),
                IconButton(
                  icon: const Icon(Icons.clear_all),
                  onPressed: controller.clearFields,
                  tooltip: l10n.clearFields,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Obx(
                () => ListView.builder(
                  itemCount: controller.fields.length,
                  itemBuilder: (context, index) {
                    final field = controller.fields[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: TextField(
                                controller: field.keyController,
                                decoration: InputDecoration(
                                  labelText: l10n.key,
                                  hintText: l10n.enterKey,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              flex: 3,
                              child: TextField(
                                controller: field.valueController,
                                decoration: InputDecoration(
                                  labelText: l10n.value,
                                  hintText: l10n.enterValue,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.type_specimen),
                              onPressed: () => controller.selectType(index),
                              tooltip: l10n.selectType,
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => controller.removeField(index),
                              tooltip: l10n.delete,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
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
