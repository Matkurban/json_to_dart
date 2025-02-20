import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:json_to_dart/config/global/constant.dart';
import 'package:json_to_dart/model/domain/dart/class_info.dart';
import 'package:json_to_dart/model/domain/dart/dart_type.dart';
import 'package:json_to_dart/model/domain/dart/field_info.dart';
import 'package:json_to_dart/model/domain/dart/history_item.dart';
import 'package:json_to_dart/model/domain/dart/type_info.dart';
import 'package:json_to_dart/utils/confirm_dialog.dart';
import 'package:json_to_dart/utils/message_util.dart';
import 'package:json_to_dart/widgets/dialog/preview_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syntax_highlight/syntax_highlight.dart';
import 'package:file_selector/file_selector.dart';

class JsonToDartLogic extends GetxController {
  ///json输入框控制器
  final jsonController = TextEditingController();

  ///类名输入框控制器
  final classNameController = TextEditingController(text: 'MyModel');

  ///是否为空
  RxBool nonNullable = true.obs;

  ///是否生成toJson
  RxBool generateToJson = true.obs;

  ///是否生成formJson
  RxBool generateFromJson = true.obs;

  ///生成的dart类
  RxString dartCode = ''.obs;

  // 历史记录
  final history = <HistoryItem>[].obs;

  ///历史记录的key
  final _historyKey = 'conversion_history';

  ///高亮
  late Highlighter highlighter;

  @override
  void onInit() async {
    super.onInit();
    var theme = await HighlighterTheme.loadLightTheme();
    highlighter = Highlighter(language: 'dart', theme: theme);
    jsonController.addListener(jsonListener);
    classNameController.addListener(classNameListener);
    nonNullable.listen((newValue) => generateDartClass());
    generateToJson.listen((newValue) => generateDartClass());
    generateFromJson.listen((newValue) => generateDartClass());
    loadHistory();
  }

  ///json输入框监听
  void jsonListener() {
    _jsonIsEmpty();
    generateDartClass();
  }

  ///类名输入框监听
  void classNameListener() {
    _classNameIsEmpty();
    _jsonIsEmpty();
    generateDartClass();
  }

  void _classNameIsEmpty() {
    String classNameText = classNameController.text.trim();
    if (classNameText.isEmpty) {
      dartCode('');
      return;
    }
  }

  void _jsonIsEmpty() {
    String jsonText = jsonController.text.trim();
    if (jsonText.isEmpty) {
      dartCode('');
      return;
    }
  }

  void generateDartClass() {
    try {
      _jsonNullWarning();
      _classNameNullWarning();
      final parsedJson = json.decode(jsonController.text.trim());
      dartCode.value = _generateCode(parsedJson);
    } catch (e) {
      _jsonConvertWarning();
    }
  }

  void formatJson() {
    try {
      _jsonNullWarning();
      final parsedJson = json.decode(jsonController.text);
      jsonController.text = const JsonEncoder.withIndent('  ').convert(parsedJson);
    } catch (e) {
      _jsonConvertWarning();
    }
  }

  String _generateCode(dynamic jsonData) {
    if (jsonData is! Map<String, dynamic>) {
      MessageUtil.showWarning(title: '转换异常 ', content: '请输入正确格式的json后操作');
      return '';
    }
    final buffer = StringBuffer();
    final classes = <String, Map<String, dynamic>>{};
    final classStack = [ClassInfo(classNameController.text, jsonData)];
    while (classStack.isNotEmpty) {
      final current = classStack.removeLast();
      if (classes.containsKey(current.name)) continue;
      final fields = _parseFields(current.data, classes, classStack, current.name);
      _writeClassHeader(current.name, buffer);
      _writeClassBody(current.name, fields, buffer);
      classes[current.name] = current.data;
    }
    return buffer.toString().trim();
  }

  void _writeClassHeader(String className, StringBuffer buffer) =>
      buffer.writeln('class $className {');

  void _writeClassBody(String className, List<FieldInfo> fields, StringBuffer buffer) {
    // 字段声明
    for (final f in fields) {
      final nullability =
          f.isDynamic
              ? ''
              : nonNullable.value
              ? ''
              : '?';
      buffer.writeln('  final ${f.type}$nullability ${f.name};');
    }
    buffer.write('\n');
    buffer.write('''
  $className({
    ${fields.map((f) {
      final required = nonNullable.value && !f.isDynamic ? 'required ' : '';
      return '$required this.${f.name},';
    }).join('\n    ')}
  });
  ''');
    buffer.write('\n');

    if (generateFromJson.value) {
      buffer.write('''
  factory $className.fromJson(Map<String, dynamic> json) {
    return $className(
      ${fields.map((f) => _fromJsonLine(f)).join('\n      ')}
    );
  }
    ''');
      buffer.write('\n');
    }

    // toJson
    if (generateToJson.value) {
      buffer.write('''
  Map<String, dynamic> toJson() => {
    ${fields.map((f) => _toJsonLine(f)).join('\n    ')}
  };''');
      buffer.writeln('\n');
    }
    buffer.writeln('}');
    buffer.writeln('\n');
  }

  String _fromJsonLine(FieldInfo f) {
    String line;
    if (f.isCustomType) {
      if (nonNullable.value) {
        line = '${f.name}: ${f.type}.fromJson(json[\'${f.jsonKey}\'] as Map<String, dynamic>)';
      } else {
        line =
            '${f.name}: json[\'${f.jsonKey}\'] != null ? ${f.type}.fromJson(json[\'${f.jsonKey}\'] as Map<String, dynamic>) : null';
      }
    } else if (f.isListOfCustomType) {
      if (nonNullable.value) {
        line =
            '${f.name}: (json[\'${f.jsonKey}\'] as List).map((e) => ${f.listType}.fromJson(e as Map<String, dynamic>)).toList()';
      } else {
        line =
            '${f.name}: json[\'${f.jsonKey}\'] != null ? (json[\'${f.jsonKey}\'] as List).map((e) => ${f.listType}.fromJson(e as Map<String, dynamic>)).toList() : null';
      }
    } else if (f.isList) {
      if (nonNullable.value) {
        line = '${f.name}: json[\'${f.jsonKey}\'] as List<${f.baseType}>';
      } else {
        line =
            '${f.name}: json[\'${f.jsonKey}\'] != null ? json[\'${f.jsonKey}\'] as List<${f.baseType}> : null';
      }
    } else {
      if (nonNullable.value) {
        line = '${f.name}: json[\'${f.jsonKey}\'] as ${f.baseType}';
      } else {
        line =
            '${f.name}: json[\'${f.jsonKey}\'] != null ? json[\'${f.jsonKey}\'] as ${f.baseType} : null';
      }
    }
    return '$line,'; // 添加逗号
  }

  String _toJsonLine(FieldInfo f) {
    String line;
    if (f.isCustomType) {
      if (nonNullable.value) {
        line = '\'${f.jsonKey}\': ${f.name}.toJson()';
      } else {
        line = '\'${f.jsonKey}\': ${f.name}?.toJson()';
      }
    } else if (f.isListOfCustomType) {
      if (nonNullable.value) {
        line = '\'${f.jsonKey}\': ${f.name}.map((e) => e.toJson()).toList()';
      } else {
        line = '\'${f.jsonKey}\': ${f.name}?.map((e) => e.toJson())?.toList()';
      }
    } else {
      if (nonNullable.value) {
        line = '\'${f.jsonKey}\': ${f.name}';
      } else {
        line = '\'${f.jsonKey}\': ${f.name}';
      }
    }
    return '$line,'; // 添加逗号
  }

  List<FieldInfo> _parseFields(
    Map<String, dynamic> data,
    Map<String, Map<String, dynamic>> classes,
    List<ClassInfo> classStack,
    String parentClassName,
  ) {
    return data.entries.map((entry) {
      final jsonKey = entry.key;
      final value = entry.value;
      final typeInfo = _resolveType(value, jsonKey, classes, classStack, parentClassName);
      final fieldName = _convertFieldName(jsonKey);

      return FieldInfo(
        jsonKey: jsonKey,
        name: fieldName,
        type: typeInfo.type,
        baseType: typeInfo.baseType,
        listType: typeInfo.listType,
        isDynamic: typeInfo.isDynamic,
        isCustomType: typeInfo.isCustomType,
        isList: typeInfo.isList,
        isListOfCustomType: typeInfo.isListOfCustomType,
        isBasicListType: typeInfo.isBasicListType,
        defaultValue: nonNullable.value && typeInfo.nullable ? typeInfo.defaultValue : null,
      );
    }).toList();
  }

  TypeInfo _resolveType(
    dynamic value,
    String key,
    Map<String, Map<String, dynamic>> classes,
    List<ClassInfo> classStack,
    String parentClassName,
  ) {
    if (value == null) {
      return TypeInfo(type: 'dynamic', baseType: 'dynamic', isDynamic: true, nullable: true);
    }

    if (value is Map) {
      final className = _classNameFromKey(key, parentClassName);
      classStack.add(ClassInfo(className, value.cast<String, dynamic>()));
      return TypeInfo(
        type: className,
        baseType: className,
        isCustomType: true,
        defaultValue: nonNullable.value ? '$className()' : null,
      );
    }

    if (value is List) {
      if (value.isEmpty) {
        return TypeInfo(
          type: 'List<dynamic>',
          baseType: 'List',
          isDynamic: true,
          isList: true,
          defaultValue: '[]',
        );
      }

      final firstElement = value.first;
      if (firstElement is Map) {
        final className = '${_classNameFromKey(key, parentClassName)}Item';
        classStack.add(ClassInfo(className, firstElement.cast<String, dynamic>()));
        return TypeInfo(
          type: 'List<$className>',
          baseType: 'List',
          listType: className,
          isList: true,
          isListOfCustomType: true,
          defaultValue: nonNullable.value ? '[]' : null,
        );
      }

      final elementType = firstElement.runtimeType;
      final dartType = _dartTypeMap[elementType]?.type ?? 'dynamic';
      return TypeInfo(
        type: 'List<$dartType>',
        baseType: dartType,
        isList: true,
        isBasicListType: true,
        defaultValue: nonNullable.value ? '[]' : null,
      );
    }

    final type = value.runtimeType;
    final typeDesc = _dartTypeMap[type] ?? _dartTypeMap[Null]!;

    return TypeInfo(
      type: typeDesc.type,
      baseType: typeDesc.type,
      defaultValue: nonNullable.value ? typeDesc.defaultValue : null,
      nullable: !nonNullable.value,
    );
  }

  String _convertFieldName(String key) {
    // 1. 标准化处理：替换所有非字母数字字符为下划线，并合并连续下划线
    String sanitized = key
        .replaceAll(RegExp(r'[^a-zA-Z0-9]+'), '_') // 合并连续特殊字符为单个下划线
        .replaceAll(RegExp(r'_+'), '_'); // 确保没有连续下划线

    // 2. 分割下划线并过滤空片段
    List<String> parts = sanitized.split('_').where((p) => p.isNotEmpty).toList();

    // 3. 处理每个片段
    List<String> processedParts =
        parts.map((part) {
          // 处理纯数字片段（如 "123" → "_123"）
          if (RegExp(r'^\d+$').hasMatch(part)) {
            return '_$part';
          }

          // 处理数字开头的混合片段（如 "2fa" → "fa2"）
          if (RegExp(r'^\d').hasMatch(part)) {
            return part
                .split(RegExp(r'(?<=\d)(?=\D)|(?<=\D)(?=\d)')) // 分割数字和字母
                .reversed
                .join(); // 反转顺序
          }

          return part;
        }).toList();

    // 4. 转换为大驼峰格式（首字母大写）
    processedParts = processedParts.map((p) => p[0].toUpperCase() + p.substring(1)).toList();

    // 5. 转换为小驼峰格式（首个字母小写）
    String camelCase =
        processedParts.isNotEmpty
            ? processedParts.first[0].toLowerCase() +
                processedParts.first.substring(1) +
                processedParts.sublist(1).join()
            : '';

    // 6. 处理保留字和空值
    return _sanitizeFieldName(camelCase);
  }

  String _sanitizeFieldName(String name) {
    // 处理保留字
    if (reservedWords.contains(name)) {
      return '${name}Field';
    }
    // 处理空值
    if (name.isEmpty) {
      return 'unnamedField';
    }
    // 处理数字开头（经过前面处理不应该出现）
    if (RegExp(r'^[0-9]').hasMatch(name)) {
      return '_$name';
    }
    return name;
  }

  String _classNameFromKey(String key, String parentClassName) {
    // 处理父类名中的下划线和特殊字符
    final parentParts = parentClassName.split(RegExp(r'_+'));
    final processedParent =
        parentParts.map((part) {
          if (part.isEmpty) return '';
          return '${part[0].toUpperCase()}${part.substring(1)}';
        }).join();

    // 处理字段名中的各种分隔符
    final keyParts = key.split(RegExp(r'[^a-zA-Z0-9]'));
    final processedKey =
        keyParts.map((part) {
          if (part.isEmpty) return '';
          return '${part[0].toUpperCase()}${part.substring(1).toLowerCase()}';
        }).join();

    // 组合生成类名
    final baseName = '$processedParent$processedKey';

    // 处理保留字（示例）
    final reservedWords = {'Class', 'Switch', 'Default'};
    return reservedWords.contains(baseName) ? '${baseName}Class' : baseName;
  }

  static const _dartTypeMap = {
    String: DartType('String', 'String', ".toString()", "''"),
    int: DartType('int', 'int', " ?? 0", '0'),
    double: DartType('double', 'double', " ?? 0.0", '0.0'),
    bool: DartType('bool', 'bool', " ?? false", 'false'),
    Null: DartType('dynamic', 'dynamic', '', null),
  };

  // 添加历史记录
  void addHistory() async {
    _jsonNullWarning();
    _classNameNullWarning();
    final newItem = HistoryItem(
      title: classNameController.text,
      subtitle: DateTime.now().toString().substring(0, 10),
      json: jsonController.text,
      dartCode: dartCode.value,
      timestamp: DateTime.now(),
    );

    // 保存到 SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getStringList(_historyKey) ?? [];
    historyJson.add(jsonEncode(newItem.toJson()));
    await prefs.setStringList(_historyKey, historyJson);

    // 更新控制器列表
    history.insert(0, newItem);
  }

  // 加载历史记录
  void loadHistory() async {
    final prefs = Get.find<SharedPreferences>();
    final historyJson = prefs.getStringList(_historyKey) ?? [];

    // 更新控制器的 history 列表
    history.assignAll(
      historyJson.map((jsonStr) => HistoryItem.fromJson(jsonDecode(jsonStr))).toList(),
    );
  }

  //================ 本地存储实现 ================

  // 清空历史记录
  void clearHistory() async {
    ConfirmDialog.showConfirmDialog(
      title: '确认清空吗',
      content: '清空后将无法恢复，请谨慎操作。',
      onConfirm: () async {
        history.clear();
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove(_historyKey);
      },
    );
  }

  void deleteOne(HistoryItem item) {
    ConfirmDialog.showConfirmDialog(
      title: '确认删除吗',
      content: '您即将删除单条历史记录，删除后将无法恢复，请谨慎操作。',
      onConfirm: () async {
        bool remove = history.remove(item);
        if (remove) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.remove(_historyKey);
          prefs.setStringList(
            _historyKey,
            history.map((item) => jsonEncode(item.toJson())).toList(),
          );
        }
      },
    );
  }

  ///预览Json
  void previewJson(BuildContext context) {
    _jsonNullWarning();
    PreviewDialog.showPreviewJsonDialog(context, jsonController.text);
  }

  /// 保存为文件
  void saveToFile(BuildContext context) async {
    _jsonNullWarning();
    _classNameNullWarning();

    // 生成文件名：大驼峰类名转下划线格式
    String fileName =
        classNameController.text
            .replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (Match m) => '${m[1]}_${m[2]}')
            .toLowerCase();
    if (!fileName.endsWith('.dart')) {
      fileName += '.dart';
    }

    // 获取Dart代码内容
    final dartCodeContent = dartCode.value;

    try {
      final FileSaveLocation? result = await getSaveLocation(
        suggestedName: fileName,
        acceptedTypeGroups: [
          XTypeGroup(label: 'dart', extensions: ['.dart']),
        ],
      );
      if (result == null) {
        return;
      }
      final Uint8List fileData = Uint8List.fromList(dartCodeContent.codeUnits);
      const String mimeType = 'text/plain';
      final XFile textFile = XFile.fromData(fileData, mimeType: mimeType, name: fileName);
      await textFile.saveTo(result.path);
      MessageUtil.showSuccess(title: '操作提示', content: '文件保存成功');
    } catch (e) {
      MessageUtil.showError(title: '保存失败', content: '文件保存异常: ${e.toString()}');
    }
  }

  ///json为空的时候操作提示
  void _jsonNullWarning() {
    if (jsonController.text.trim().isEmpty) {
      MessageUtil.showError(title: '操作提示', content: '请输入Json后操作');
      return;
    }
  }

  ///类名为空时的提示
  void _classNameNullWarning() {
    if (classNameController.text.trim().isEmpty) {
      MessageUtil.showError(title: '操作提示', content: '请输入类名后操作');
      return;
    }
  }

  ///json为null或者格式异常，转换异常时的提示
  void _jsonConvertWarning() {
    dartCode.value = '';
    MessageUtil.showWarning(title: '转换异常 ', content: '请输入正确格式的json后操作');
  }

  @override
  void onClose() {
    jsonController.removeListener(jsonListener);
    classNameController.removeListener(classNameListener);
    jsonController.dispose();
    classNameController.dispose();
    super.onClose();
  }
}
