import 'package:get/get.dart';
import 'package:flutter/material.dart' show TextEditingController;
import 'package:json_to_dart/screens/json/logic/json_generator_logic.dart';

class JsonField {
  final TextEditingController keyController;
  final TextEditingController valueController;
  String type;
  final int index;
  final int level;

  JsonField({
    required this.keyController,
    required this.valueController,
    this.type = 'string',
    required this.index,
    required this.level,
  });

  void dispose() {
    keyController.dispose();
    valueController.dispose();
  }

  JsonField createNewInstance({String? newType, int? newIndex, int? newLevel}) {
    final newField = JsonField(
      keyController: TextEditingController(text: keyController.text),
      valueController: TextEditingController(text: valueController.text),
      type: newType ?? type,
      index: newIndex ?? index,
      level: newLevel ?? level,
    );

    // 为新创建的字段添加监听器
    newField.keyController.addListener(() {
      Get.find<JsonGeneratorLogic>().updateJsonOutput();
    });
    newField.valueController.addListener(() {
      Get.find<JsonGeneratorLogic>().updateJsonOutput();
    });

    return newField;
  }
}
