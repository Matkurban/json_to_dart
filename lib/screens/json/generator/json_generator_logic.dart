import 'dart:convert';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:syntax_highlight/syntax_highlight.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:json_to_dart/model/domain/main/json_field.dart';
import 'package:json_to_dart/model/domain/main/json_history.dart';
import 'package:json_to_dart/screens/splash/logic/splash_logic.dart';

class JsonGeneratorLogic extends GetxController {
  final fields = <JsonField>[].obs;
  final jsonOutput = ''.obs;
  final histories = <JsonHistory>[].obs;
  final currentHistory = Rxn<JsonHistory>();

  ///代码高亮
  late Highlighter highlighter;

  final SplashLogic splashLogic = Get.find<SplashLogic>();

  @override
  void onInit() {
    super.onInit();
    highlighter = Highlighter(
      language: 'dart',
      theme: splashLogic.highlighterTheme,
    );
    addField();
    loadHistories();
  }

  @override
  void onClose() {
    for (var field in fields) {
      field.dispose();
    }
    super.onClose();
  }

  Future<void> loadHistories() async {
    try {
      final prefs = Get.find<SharedPreferences>();
      final historyJsonList = prefs.getStringList('json_histories') ?? [];
      histories.value =
          historyJsonList
              .map((json) => JsonHistory.fromJson(jsonDecode(json)))
              .toList()
            ..sort((a, b) => b.createTime.compareTo(a.createTime));
    } catch (e) {
      debugPrint('Error loading histories: $e');
    }
  }

  Future<void> saveHistories() async {
    try {
      final prefs = Get.find<SharedPreferences>();
      final historyJsonList = histories
          .map((history) => jsonEncode(history.toJson()))
          .toList();
      await prefs.setStringList('json_histories', historyJsonList);
    } catch (e) {
      debugPrint('Error saving histories: $e');
    }
  }

  Future<void> addToHistory(String name) async {
    try {
      final history = JsonHistory(
        id: const Uuid().v4(),
        name: name,
        jsonContent: jsonOutput.value,
        createTime: DateTime.now(),
      );
      histories.insert(0, history);
      await saveHistories();
    } catch (e) {
      debugPrint('Error adding to history: $e');
    }
  }

  Future<void> loadFromHistory(JsonHistory history) async {
    try {
      currentHistory.value = history;
      final jsonMap = jsonDecode(history.jsonContent) as Map<String, dynamic>;

      // 清除现有字段
      for (var field in fields) {
        field.dispose();
      }
      fields.clear();

      // 添加新字段
      jsonMap.forEach((key, value) {
        final field = JsonField(
          keyController: TextEditingController(text: key),
          valueController: TextEditingController(text: value.toString()),
          index: fields.length,
          level: 0,
        );
        field.keyController.addListener(updateJsonOutput);
        field.valueController.addListener(updateJsonOutput);
        fields.add(field);
      });

      fields.refresh();
      updateJsonOutput();
    } catch (e) {
      debugPrint('Error loading from history: $e');
    }
  }

  Future<void> deleteHistory(JsonHistory history) async {
    try {
      histories.remove(history);
      if (currentHistory.value?.id == history.id) {
        currentHistory.value = null;
      }
      await saveHistories();
    } catch (e) {
      debugPrint('Error deleting history: $e');
    }
  }

  void addField({List<JsonField>? targetList, int level = 0}) {
    final field = JsonField(
      keyController: TextEditingController(),
      valueController: TextEditingController(),
      index: targetList?.length ?? fields.length,
      level: level,
      type: 'string',
      children: <JsonField>[].obs,
    );
    field.keyController.addListener(updateJsonOutput);
    field.valueController.addListener(updateJsonOutput);
    if (targetList != null) {
      if (targetList is RxList<JsonField>) {
        targetList.add(field);
        targetList.refresh();
      } else {
        targetList.add(field);
      }
    } else {
      fields.add(field);
      fields.refresh();
    }
    updateJsonOutput();
  }

  void addChildField(JsonField parent) {
    addField(targetList: parent.children, level: parent.level + 1);
  }

  void removeField(int index, {List<JsonField>? targetList}) {
    final list = targetList ?? fields;
    list[index].dispose();
    list.removeAt(index);
    for (var i = index; i < list.length; i++) {
      final oldField = list[i];
      list[i] = oldField.createNewInstance(newIndex: i);
    }
    if (list is RxList<JsonField>) {
      list.refresh();
    }
    updateJsonOutput();
  }

  void removeChildField(JsonField parent, int childIndex) {
    removeField(childIndex, targetList: parent.children);
  }

  void clearFields() {
    for (var field in fields) {
      field.dispose();
    }
    fields.clear();
    addField();
    fields.refresh();
    updateJsonOutput();
  }

  void updateFieldType(
    int index,
    String newType, {
    List<JsonField>? targetList,
  }) {
    try {
      final list = targetList ?? fields;
      if (list.length > index) {
        final targetField = list[index];
        // 保留原有 key 和 value
        final newField = targetField.createNewInstance(
          newType: newType,
          newIndex: index,
          keyText: targetField.keyController.text,
          valueText: targetField.valueController.text,
        );
        if (newType == 'object') {
          newField.children.clear();
        }
        list[index] = newField;
        if (list is RxList<JsonField>) {
          list.refresh();
        }
        updateJsonOutput();
      }
    } catch (e) {
      debugPrint('Error updating field type: $e');
    }
  }

  void updateJsonOutput() {
    final Map<String, dynamic> jsonMap = {};
    for (var field in fields) {
      if (field.keyController.text.isNotEmpty) {
        jsonMap[field.keyController.text] = _processField(field);
      }
    }
    jsonOutput.value = JsonEncoder.withIndent('  ').convert(jsonMap);
  }

  dynamic _processField(JsonField field) {
    switch (field.type) {
      case 'number':
        final text = field.valueController.text;
        final intVal = int.tryParse(text);
        if (intVal != null) return intVal;
        final doubleVal = double.tryParse(text);
        if (doubleVal != null) return doubleVal;
        return 0;
      case 'bool':
        return field.valueController.text.toLowerCase() == 'true';
      case 'array':
        try {
          return field.valueController.text
              .split(',')
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList();
        } catch (e) {
          return [];
        }
      case 'object':
        final Map<String, dynamic> obj = {};
        for (var child in field.children) {
          if (child.keyController.text.isNotEmpty) {
            obj[child.keyController.text] = _processField(child);
          }
        }
        return obj;
      default:
        return field.valueController.text;
    }
  }

  /// 导入JSON字符串并填充到输入面板
  void importFromJson(String jsonStr) {
    try {
      final dynamic jsonData = jsonDecode(jsonStr);
      // 清除现有字段
      for (var field in fields) {
        field.dispose();
      }
      fields.clear();

      if (jsonData is Map<String, dynamic>) {
        _fillFieldsFromMap(jsonData, fields, 0);
      } else {
        // 只支持对象根节点
        Get.snackbar('导入失败', '只支持对象类型的JSON根节点');
        return;
      }
      fields.refresh();
      updateJsonOutput();
    } catch (e) {
      Get.snackbar('导入失败', 'JSON格式错误');
    }
  }

  /// 递归填充字段
  void _fillFieldsFromMap(
    Map<String, dynamic> map,
    List<JsonField> target,
    int level,
  ) {
    map.forEach((key, value) {
      String type = 'string';
      RxList<JsonField>? children;
      String valueStr = '';
      if (value is int || value is double) {
        type = 'number';
        valueStr = value.toString();
      } else if (value is bool) {
        type = 'bool';
        valueStr = value.toString();
      } else if (value is List) {
        type = 'array';
        valueStr = value.join(',');
      } else if (value is Map<String, dynamic>) {
        type = 'object';
        children = <JsonField>[].obs;
      } else if (value == null) {
        type = 'string';
        valueStr = '';
      } else {
        type = 'string';
        valueStr = value.toString();
      }

      final field = JsonField(
        keyController: TextEditingController(text: key),
        valueController: TextEditingController(
          text: type == 'object' ? '' : valueStr,
        ),
        index: target.length,
        level: level,
        type: type,
        children: children,
      );
      field.keyController.addListener(updateJsonOutput);
      field.valueController.addListener(updateJsonOutput);

      if (type == 'object' && value is Map<String, dynamic>) {
        _fillFieldsFromMap(value, field.children, level + 1);
      }
      target.add(field);
    });
  }
}
