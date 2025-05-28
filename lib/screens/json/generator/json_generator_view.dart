import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl_ui/intl_ui.dart';
import 'package:json_to_dart/config/global/constant.dart';
import 'package:json_to_dart/config/theme/app_style.dart';
import 'package:json_to_dart/screens/json/generator/widgets/generator_input_panel.dart';
import 'package:json_to_dart/screens/json/generator/widgets/generator_output_panel.dart';
import 'package:json_to_dart/screens/json/generator/json_generator_logic.dart';
import 'package:json_to_dart/screens/json/generator/widgets/json_generator_drawer.dart';

class JsonGeneratorView extends GetView<JsonGeneratorLogic> {
  const JsonGeneratorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.jsonGenerator),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.upload_file),
            tooltip: '导入JSON',
            onPressed: () => _showImportDialog(context),
          ),
          Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.history),
                onPressed: () => Scaffold.of(context).openEndDrawer(),
                tooltip: l10n.history,
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: AppStyle.smallPadding,
        child: Splitter(
          splitterThickness: 3,
          minFirstFraction: 0.2,
          maxFirstFraction: 0.6,
          splitterColor: Get.theme.colorScheme.primary,
          child1: const GeneratorOutputPanel(),
          child2: const GeneratorInputPanel(),
        ),
      ),
      endDrawer: const JsonGeneratorDrawer(),
    );
  }

  void _showImportDialog(BuildContext context) {
    final controller = Get.find<JsonGeneratorLogic>();
    final inputController = TextEditingController();
    Get.dialog(
      Dialog(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            spacing: 10,
            children: [
              Text('导入JSON', style: Get.theme.textTheme.titleLarge),
              Expanded(
                child: TextField(
                  controller: inputController,
                  textInputAction: TextInputAction.newline,
                  expands: true,
                  maxLines: null,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: const InputDecoration(hintText: '粘贴你的JSON内容'),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: () => Get.back(), child: const Text('取消')),
                  TextButton(
                    onPressed: () {
                      controller.importFromJson(inputController.text);
                      Get.back();
                    },
                    child: const Text('导入'),
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
