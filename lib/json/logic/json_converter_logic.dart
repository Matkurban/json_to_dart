// lib/controllers/json_converter_controller.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JsonConverterLogic extends GetxController {
  final jsonController = TextEditingController();
  final classNameController = TextEditingController(text: 'MyModel');

  RxBool nonNullable = true.obs;
  RxBool generateToJson = true.obs;
  RxBool generateFromJson = true.obs;

  RxString dartCode = ''.obs;
  RxString errorMessage = ''.obs;

  void generateDartClass() {
    try {
      errorMessage.value = '';
      final jsonString = jsonController.text;
      if (jsonString.isEmpty) {
        throw const FormatException('JSON cannot be empty');
      }

      final parsedJson = json.decode(jsonString);
      dartCode.value = _generateCode(parsedJson);
    } catch (e) {
      errorMessage.value = 'Error: ${e.toString().replaceAll('FormatException: ', '')}';
      dartCode.value = '';
    }
  }

  void formatJson() {
    try {
      final parsedJson = json.decode(jsonController.text);
      jsonController.text = const JsonEncoder.withIndent('  ').convert(parsedJson);
      errorMessage.value = '';
    } catch (e) {
      errorMessage.value = 'Invalid JSON format';
    }
  }

  String _generateCode(dynamic jsonData) {
    if (jsonData is! Map<String, dynamic>) {
      throw FormatException('Requires JSON object format');
    }

    final buffer = StringBuffer();
    final classes = <String, Map<String, dynamic>>{};
    final classStack = [_ClassInfo(classNameController.text, jsonData)];

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

  void _writeClassHeader(String className, StringBuffer buffer) {
    buffer.writeln('class $className {');
  }

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

    // 主构造函数
    buffer.write('''
  
  $className({
    ${fields.map((f) {
      final required = nonNullable.value && !f.isDynamic ? 'required ' : '';
      return '$required this.${f.name},';
    }).join('\n    ')}
  });
  ''');

    // fromJson
    if (generateFromJson.value) {
      buffer.write('''
    
  factory $className.fromJson(Map<String, dynamic> json) {
    return $className(
      ${fields.map((f) => _fromJsonLine(f)).join('\n      ')}
    );
  }
    ''');
    }

    // toJson
    if (generateToJson.value) {
      buffer.write('''
    
  Map<String, dynamic> toJson() => {
        ${fields.map((f) => _toJsonLine(f)).join('\n        ')}
      };
    ''');
    }

    buffer.writeln('\n}');
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
        line = '${f.name}: json[\'${f.jsonKey}\'] != null ? json[\'${f.jsonKey}\'] as List<${f.baseType}> : null';
      }
    } else {
      if (nonNullable.value) {
        line = '${f.name}: json[\'${f.jsonKey}\'] as ${f.baseType}';
      } else {
        line = '${f.name}: json[\'${f.jsonKey}\'] != null ? json[\'${f.jsonKey}\'] as ${f.baseType} : null';
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
    List<_ClassInfo> classStack,
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
    List<_ClassInfo> classStack,
    String parentClassName,
  ) {
    if (value == null) {
      return TypeInfo(type: 'dynamic', baseType: 'dynamic', isDynamic: true, nullable: true);
    }

    if (value is Map) {
      final className = _classNameFromKey(key, parentClassName);
      classStack.add(_ClassInfo(className, value.cast<String, dynamic>()));
      return TypeInfo(
        type: className,
        baseType: className,
        isCustomType: true,
        defaultValue: nonNullable.value ? '$className()' : null,
      );
    }

    if (value is List) {
      if (value.isEmpty) {
        return TypeInfo(type: 'List<dynamic>', baseType: 'List', isDynamic: true, isList: true, defaultValue: '[]');
      }

      final firstElement = value.first;
      if (firstElement is Map) {
        final className = '${_classNameFromKey(key, parentClassName)}Item';
        classStack.add(_ClassInfo(className, firstElement.cast<String, dynamic>()));
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

  // 修改 _convertFieldName 方法（在JsonConverterController类中）
  String _convertFieldName(String key) {
    // 处理特殊字符和数字开头
    final validName = key
        .replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_') // 替换非字母数字为下划线
        .split('_') // 以下划线分割
        .where((part) => part.isNotEmpty) // 移除空片段
        .map((part) {
          // 处理纯数字片段
          if (RegExp(r'^\d+$').hasMatch(part)) {
            return '_$part'; // 纯数字添加前缀
          }
          // 处理数字开头（非纯数字）
          if (RegExp(r'^\d').hasMatch(part)) {
            final letters = part.split(RegExp(r'(?<=[a-zA-Z])(?=\d)|(?<=\d)(?=[a-zA-Z])'));
            return letters.reversed.join();
          }
          return part;
        })
        .map((part) => _capitalizeFirst(part)) // 首字母大写
        .join('');

    // 转换为小驼峰
    final camelCase = _capitalizeFirst(validName, lowerFirst: true);

    // 处理保留字和空值
    return _sanitizeFieldName(camelCase);
  }

  String _capitalizeFirst(String s, {bool lowerFirst = false}) {
    if (s.isEmpty) return '';
    final first = lowerFirst ? s[0].toLowerCase() : s[0].toUpperCase();
    return '$first${s.substring(1).toLowerCase()}';
  }

  String _sanitizeFieldName(String name) {
    const reservedWords = {'default', 'class', 'switch', 'async'};

    // 处理保留字
    if (reservedWords.contains(name)) {
      return '${name}Field';
    }

    // 处理数字开头
    if (RegExp(r'^[0-9]').hasMatch(name)) {
      return '_$name';
    }

    // 处理空字段名
    return name.isEmpty ? 'unnamedField' : name;
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
    String: _DartType('String', 'String', ".toString()", "''"),
    int: _DartType('int', 'int', " ?? 0", '0'),
    double: _DartType('double', 'double', " ?? 0.0", '0.0'),
    bool: _DartType('bool', 'bool', " ?? false", 'false'),
    Null: _DartType('dynamic', 'dynamic', '', null),
  };
  // 布局状态
  final showHistoryPanel = true.obs;
  final inputPanelRatio = 5.obs;
  final outputPanelRatio = 5.obs;

  // 历史记录
  final history = <HistoryItem>[].obs;
  final _historyKey = 'conversion_history';
  
  @override
  void onInit() {
    super.onInit();
    loadHistory();
  }


 void updatePanelRatio(double delta) {
  const minRatio = 1;
  const maxRatio = 10;
  final deltaStep = delta > 0 ? 1 : -1;

  final newInput = (inputPanelRatio.value + deltaStep).clamp(minRatio, maxRatio);
  final newOutput = (outputPanelRatio.value - deltaStep).clamp(minRatio, maxRatio);

  if (newInput + newOutput == inputPanelRatio.value + outputPanelRatio.value) {
    inputPanelRatio.value = newInput;
    outputPanelRatio.value = newOutput;
  }
}

  // 添加历史记录
void addHistory(String jsonData, String dartCode) async {
  final newItem = HistoryItem(
    title: '转换记录 ${DateTime.now().toString().substring(11, 16)}',
    subtitle: DateTime.now().toString().substring(0, 10),
    json: jsonData,
    dartCode: dartCode,
    timestamp: DateTime.now(),
  );

  // 保存到 SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  final historyJson = prefs.getStringList('history') ?? [];
  historyJson.add(jsonEncode(newItem.toJson()));
  await prefs.setStringList('history', historyJson);

  // 更新控制器列表
  history.insert(0, newItem);
}

  // 加载历史记录
 void loadHistory() async {
  final prefs = await SharedPreferences.getInstance();
  final historyJson = prefs.getStringList('history') ?? [];
  
  // 更新控制器的 history 列表
  history.assignAll(
    historyJson.map((jsonStr) {
      try {
        return HistoryItem.fromJson(jsonDecode(jsonStr));
      } catch (e) {
        print('解析历史记录失败: $e');
        return null;
      }
    }).where((item) => item != null).cast<HistoryItem>().toList()
  );
}

  //================ 本地存储实现 ================



  // 清空历史记录
  Future<void> clearHistory() async {
    history.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
  }
}

// 历史记录模型类
class HistoryItem {
  final String title;
  final String subtitle;
  final String json;
  final String dartCode;
  final DateTime timestamp;

  HistoryItem({
    required this.title,
    required this.subtitle,
    required this.json,
    required this.dartCode,
    required this.timestamp,
  });

  // 将对象转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subtitle': subtitle,
      'json': json,
      'dartCode': dartCode,
      'timestamp': timestamp.millisecondsSinceEpoch, // 将 DateTime 转换为时间戳
    };
  }

  // 从 JSON 创建对象
  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      json: json['json'] as String,
      dartCode: json['dartCode'] as String,
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp'] as int), // 从时间戳恢复 DateTime
    );
  }
}

// Helper Classes
class TypeInfo {
  final String type;
  final String baseType;
  final String? listType;
  final bool isDynamic;
  final bool isCustomType;
  final bool isList;
  final bool isListOfCustomType;
  final bool isBasicListType;
  final bool nullable;
  final String? defaultValue;

  TypeInfo({
    required this.type,
    required this.baseType,
    this.listType,
    this.isDynamic = false,
    this.isCustomType = false,
    this.isList = false,
    this.isListOfCustomType = false,
    this.isBasicListType = false,
    this.nullable = true,
    this.defaultValue,
  });
}

class _DartType {
  final String type;
  final String castType;
  final String cast;
  final String? defaultValue;

  const _DartType(this.type, this.castType, this.cast, [this.defaultValue]);
}

class FieldInfo {
  final String jsonKey;
  final String name;
  final String type;
  final String baseType;
  final String? listType;
  final bool isDynamic;
  final bool isCustomType;
  final bool isList;
  final bool isListOfCustomType;
  final bool isBasicListType;
  final String? defaultValue;

  FieldInfo({
    required this.jsonKey,
    required this.name,
    required this.type,
    required this.baseType,
    this.listType,
    this.isDynamic = false,
    this.isCustomType = false,
    this.isList = false,
    this.isListOfCustomType = false,
    this.isBasicListType = false,
    this.defaultValue,
  });
}

class _ClassInfo {
  final String name;
  final Map<String, dynamic> data;

  _ClassInfo(this.name, this.data);
}
