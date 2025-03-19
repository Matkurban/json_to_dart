import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:json_to_dart/config/global/constant.dart';
import 'package:json_to_dart/config/theme/app_style.dart';
import 'package:json_to_dart/screens/json/widgets/model_view_pane.dart';
import 'package:json_to_dart/screens/json/widgets/title_text.dart';
import '../logic/json_generator_logic.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class JsonGeneratorView extends GetView<JsonGeneratorLogic> {
  const JsonGeneratorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.jsonGenerator),
        centerTitle: true,
        actions: [
          Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.history),
                onPressed: () => Scaffold.of(context).openEndDrawer(),
                tooltip: AppLocalizations.of(context)!.history,
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
                AppLocalizations.of(context)!.history,
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
                TitleText(text: AppLocalizations.of(context)!.jsonOutput),
                const Spacer(),
                IconButton(
                  onPressed: () => previewJson(context, controller.jsonOutput.value),
                  icon: const Icon(Icons.visibility),
                  tooltip: AppLocalizations.of(context)!.previewJsonView,
                ),
                IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: () => controller.copyToClipboard(controller.jsonOutput.value),
                  tooltip: AppLocalizations.of(context)!.copyJson,
                ),
                IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: () => _showSaveDialog(context),
                  tooltip: AppLocalizations.of(context)!.saveToHistory,
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
                TitleText(text: AppLocalizations.of(context)!.jsonFields),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: controller.addField,
                  tooltip: AppLocalizations.of(context)!.addField,
                ),
                IconButton(
                  icon: const Icon(Icons.clear_all),
                  onPressed: controller.clearFields,
                  tooltip: AppLocalizations.of(context)!.clearFields,
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
                                  labelText: AppLocalizations.of(context)!.key,
                                  hintText: AppLocalizations.of(context)!.enterKey,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              flex: 3,
                              child: TextField(
                                controller: field.valueController,
                                decoration: InputDecoration(
                                  labelText: AppLocalizations.of(context)!.value,
                                  hintText: AppLocalizations.of(context)!.enterValue,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.type_specimen),
                              onPressed: () => controller.selectType(index),
                              tooltip: AppLocalizations.of(context)!.selectType,
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => controller.removeField(index),
                              tooltip: AppLocalizations.of(context)!.delete,
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
        title: Text(AppLocalizations.of(context)!.saveToHistory),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.name,
            hintText: AppLocalizations.of(context)!.enterName,
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text(AppLocalizations.of(context)!.cancel)),
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                controller.addToHistory(nameController.text);
                Get.back();
              }
            },
            child: Text(AppLocalizations.of(context)!.save),
          ),
        ],
      ),
    );
  }
}
