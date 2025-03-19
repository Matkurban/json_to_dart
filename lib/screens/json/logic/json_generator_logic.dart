import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:json_to_dart/screens/splash/logic/splash_logic.dart';
import 'package:json_to_dart/screens/json/model/json_history.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syntax_highlight/syntax_highlight.dart';
import 'package:uuid/uuid.dart';
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
    newField.keyController.addListener(() => Get.find<JsonGeneratorLogic>().updateJsonOutput());
    newField.valueController.addListener(() => Get.find<JsonGeneratorLogic>().updateJsonOutput());

    return newField;
  }
}

class JsonGeneratorLogic extends GetxController {
  static JsonGeneratorLogic get to => Get.find();
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
    highlighter = Highlighter(language: 'dart', theme: splashLogic.highlighterTheme);
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
          historyJsonList.map((json) => JsonHistory.fromJson(jsonDecode(json))).toList()
            ..sort((a, b) => b.createTime.compareTo(a.createTime));
    } catch (e) {
      debugPrint('Error loading histories: $e');
    }
  }

  Future<void> saveHistories() async {
    try {
      final prefs = Get.find<SharedPreferences>();
      final historyJsonList = histories.map((history) => jsonEncode(history.toJson())).toList();
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

  void addField() {
    final field = JsonField(
      keyController: TextEditingController(),
      valueController: TextEditingController(),
      index: fields.length,
      level: 0,
    );
    field.keyController.addListener(updateJsonOutput);
    field.valueController.addListener(updateJsonOutput);
    fields.add(field);
    fields.refresh();
    updateJsonOutput();
  }

  void removeField(int index) {
    fields[index].dispose();
    fields.removeAt(index);
    // 更新剩余字段的索引
    for (var i = index; i < fields.length; i++) {
      final oldField = fields[i];
      fields[i] = oldField.createNewInstance(newIndex: i);
    }
    fields.refresh();
    updateJsonOutput();
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

  void selectType(int index) {
    final context = Get.context!;
    final l10n = AppLocalizations.of(context)!;

    Get.dialog(
      AlertDialog(
        title: Text(l10n.selectType),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(l10n.string),
              onTap: () {
                _updateFieldType(index, 'string');
                Get.back();
              },
            ),
            ListTile(
              title: Text(l10n.number),
              onTap: () {
                _updateFieldType(index, 'number');
                Get.back();
              },
            ),
            ListTile(
              title: Text(l10n.boolean),
              onTap: () {
                _updateFieldType(index, 'boolean');
                Get.back();
              },
            ),
            ListTile(
              title: Text(l10n.array),
              onTap: () {
                _updateFieldType(index, 'array');
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _updateFieldType(int index, String newType) {
    try {
      if (fields.length > index) {
        final targetField = fields[index];
        final newField = targetField.createNewInstance(newType: newType, newIndex: index);
        fields[index] = newField;
        updateJsonOutput();
        fields.refresh();
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
        return double.tryParse(field.valueController.text) ?? 0;
      case 'boolean':
        return field.valueController.text.toLowerCase() == 'true';
      case 'array':
        try {
          return field.valueController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
        } catch (e) {
          return [];
        }
      default:
        return field.valueController.text;
    }
  }

  void copyToClipboard(String text) {
    final context = Get.context!;
    final l10n = AppLocalizations.of(context)!;

    Clipboard.setData(ClipboardData(text: text));
    Get.snackbar(l10n.success, l10n.copiedToClipboard, snackPosition: SnackPosition.BOTTOM);
  }
}
