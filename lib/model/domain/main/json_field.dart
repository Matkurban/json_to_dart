import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:json_to_dart/screens/json/generator/json_generator_logic.dart';

class JsonField {
  final TextEditingController keyController;
  final TextEditingController valueController;
  final int index;
  final int level;
  final String type;
  RxList<JsonField> children;

  JsonField({
    required this.keyController,
    required this.valueController,
    required this.index,
    required this.level,
    this.type = 'string',
    RxList<JsonField>? children,
  }) : children = children ?? <JsonField>[].obs;

  void dispose() {
    keyController.dispose();
    valueController.dispose();
    for (var child in children) {
      child.dispose();
    }
  }

  JsonField createNewInstance({
    String? newType,
    int? newIndex,
    String? keyText,
    String? valueText,
  }) {
    final newKeyController = TextEditingController(
      text: keyText ?? keyController.text,
    );
    final newValueController = TextEditingController(
      text: valueText ?? valueController.text,
    );
    final newField = JsonField(
      keyController: newKeyController,
      valueController: newValueController,
      index: newIndex ?? index,
      level: level,
      type: newType ?? type,
      children:
          (newType == 'object')
              ? <JsonField>[].obs
              : (newType == null && type == 'object')
              ? children.map((c) => c.createNewInstance()).toList().obs
              : <JsonField>[].obs,
    );
    // 添加监听，保证切换类型后内容变动能刷新
    newKeyController.addListener(() {
      // 这里不能直接调用 updateJsonOutput，需要通过逻辑层
      try {
        final logic = Get.find<JsonGeneratorLogic>();
        logic.updateJsonOutput();
      } catch (_) {}
    });
    newValueController.addListener(() {
      try {
        final logic = Get.find<JsonGeneratorLogic>();
        logic.updateJsonOutput();
      } catch (_) {}
    });
    return newField;
  }
}
