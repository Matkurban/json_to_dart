import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:json_to_dart/screens/json/generator/json_generator_logic.dart';

class JsonField {
  final TextEditingController keyController;
  final TextEditingController valueController;
  final int index;
  final int level;
  final RxString type = 'string'.obs; // 改为响应式类型
  RxList<JsonField> children;
  final RxBool boolValue = false.obs;
  bool _listenersAdded = false; // 防止重复添加监听器

  JsonField({
    required this.keyController,
    required this.valueController,
    required this.index,
    required this.level,
    String? initialType,
    RxList<JsonField>? children,
  }) : children = children ?? <JsonField>[].obs {
    if (initialType != null) {
      type.value = initialType;
    }
    _setupListeners();
    _updateBoolValue();
  }

  void _setupListeners() {
    if (_listenersAdded) return;
    _listenersAdded = true;

    keyController.addListener(_onFieldChange);
    valueController.addListener(_onFieldChange);

    // 监听类型变化
    type.listen((newType) {
      _onTypeChanged(newType);
    });
  }

  void _onFieldChange() {
    try {
      if (Get.isRegistered<JsonGeneratorLogic>()) {
        Get.find<JsonGeneratorLogic>().updateJsonOutput();
      }
    } catch (_) {}
  }

  void _onTypeChanged(String newType) {
    if (newType == 'bool') {
      _updateBoolValue();
    } else if (newType == 'object') {
      // 清理子字段
      for (var child in children) {
        child.dispose();
      }
      children.clear();
    }
    _onFieldChange();
  }

  void _updateBoolValue() {
    if (type.value == 'bool') {
      boolValue.value = valueController.text.toLowerCase() == 'true';
    }
  }

  // 简化类型更新，不再重建整个字段
  void updateType(String newType) {
    if (type.value == newType) return;

    type.value = newType;

    // 根据新类型清理或设置默认值
    if (newType == 'bool' && valueController.text.isEmpty) {
      valueController.text = 'false';
      boolValue.value = false;
    } else if (newType == 'number' && valueController.text.isEmpty) {
      valueController.text = '0';
    } else if (newType == 'string' && valueController.text.isEmpty) {
      valueController.text = '';
    }
  }

  void dispose() {
    keyController.dispose();
    valueController.dispose();
    boolValue.close();
    type.close();
    for (var child in children) {
      child.dispose();
    }
  }

  // 保留创建新实例的方法，但简化实现
  JsonField createNewInstance({
    String? newType,
    int? newIndex,
    String? keyText,
    String? valueText,
  }) {
    final newKeyController = TextEditingController(text: keyText ?? keyController.text);
    final newValueController = TextEditingController(text: valueText ?? valueController.text);

    return JsonField(
      keyController: newKeyController,
      valueController: newValueController,
      index: newIndex ?? index,
      level: level,
      initialType: newType ?? type.value,
      children: (newType == 'object' || (newType == null && type.value == 'object'))
          ? children.map((c) => c.createNewInstance()).toList().obs
          : <JsonField>[].obs,
    );
  }
}
