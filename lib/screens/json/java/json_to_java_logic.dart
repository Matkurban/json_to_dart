import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:json_to_dart/utils/message_util.dart';
import 'package:syntax_highlight/syntax_highlight.dart';
import 'package:json_to_dart/config/global/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:json_to_dart/model/domain/java/java_type.dart';
import 'package:json_to_dart/model/domain/dart/class_info.dart';
import 'package:json_to_dart/widgets/dialog/confirm_dialog.dart';
import 'package:json_to_dart/model/domain/main/history_item.dart';
import 'package:json_to_dart/model/domain/java/java_type_info.dart';
import 'package:json_to_dart/model/domain/java/java_field_info.dart';
import 'package:json_to_dart/screens/splash/logic/splash_logic.dart';

class JsonToJavaLogic extends GetxController {
  // Controllers
  final jsonController = TextEditingController();
  final classNameController = TextEditingController(text: 'MyModel');
  final packageNameController = TextEditingController();

  // Configuration flags
  final RxBool generateGetterSetter = true.obs;
  final RxBool generateBuilder = false.obs;
  final RxBool generateToString = true.obs;
  final RxBool useOptional = false.obs;
  final RxBool useLombok = false.obs;

  // Generated code
  final RxString javaCode = ''.obs;

  // History
  final history = <HistoryItem>[].obs;

  // Code highlighter
  late Highlighter highlighter;

  final SplashLogic splashLogic = Get.find<SplashLogic>();

  static const Map<String, JavaType> _javaTypeMap = {
    'String': JavaType('String', 'String', 'null', '""'),
    'int': JavaType('Integer', 'int', '0', '0'),
    'double': JavaType('Double', 'double', '0.0', '0.0'),
    'bool': JavaType('Boolean', 'boolean', 'false', 'false'),
    'Null': JavaType('Object', 'Object', 'null', 'null'),
  };

  Timer? _jsonDebounce;
  Timer? _classNameDebounce;
  Timer? _packageNameDebounce;

  @override
  void onInit() {
    super.onInit();
    // 兜底处理 theme 为空
    final theme = splashLogic.highlighterTheme;
    highlighter = Highlighter(language: 'dart', theme: theme);
    jsonController.addListener(jsonListener);
    packageNameController.addListener(packageNameListener);
    classNameController.addListener(classNameListener);
    generateGetterSetter.listen((newValue) {
      generateJavaClass();
      if (newValue) {
        generateBuilder(false);
        useLombok(false);
      }
    });
    generateBuilder.listen((newValue) {
      generateJavaClass();
      if (newValue) {
        useLombok(true);
        generateGetterSetter(false);
        generateToString(false);
      }
    });
    generateToString.listen((_) => generateJavaClass());
    useOptional.listen((_) => generateJavaClass());
    useLombok.listen((newValue) {
      generateJavaClass();
      if (newValue) {
        generateGetterSetter(false);
        generateToString(false);
      }
    });
  }

  @override
  void onReady() {
    super.onReady();
    history.assignAll(splashLogic.javaHistory);
  }

  void jsonListener() {
    // Cancel any previous timer
    _jsonDebounce?.cancel();

    // Create a new timer
    _jsonDebounce = Timer(const Duration(milliseconds: 500), () {
      String jsonText = jsonController.text.trim();
      if (jsonText.isEmpty) {
        javaCode.value = '';
      } else {
        generateJavaClass();
      }
    });
  }

  void classNameListener() {
    // Cancel any previous timer
    _classNameDebounce?.cancel();

    // Create a new timer
    _classNameDebounce = Timer(const Duration(milliseconds: 500), () {
      String classNameText = classNameController.text.trim();
      if (classNameText.isEmpty) {
        javaCode.value = '';
      } else {
        generateJavaClass();
      }
    });
  }

  void packageNameListener() {
    // Cancel any previous timer
    _packageNameDebounce?.cancel();

    // Create a new timer
    _packageNameDebounce = Timer(const Duration(milliseconds: 500), () {
      generateJavaClass();
    });
  }

  void generateJavaClass() {
    try {
      if (jsonController.text.trim().isEmpty ||
          classNameController.text.trim().isEmpty) {
        javaCode.value = '';
        return;
      }
      final parsedJson = json.decode(jsonController.text.trim());
      javaCode.value = _generateCode(parsedJson);
    } catch (e) {
      _jsonConvertWarning();
    }
  }

  String _generateCode(dynamic jsonData) {
    if (jsonData is! Map<String, dynamic>) {
      MessageUtil.showWarning(
        title: l10n.conversionError,
        content: l10n.enterValidJsonPrompt,
      );
      return '';
    }

    final buffer = StringBuffer();
    final classes = <String, Map<String, dynamic>>{};
    final classStack = [
      ClassInfo(_sanitizeClassName(classNameController.text.trim()), jsonData),
    ];

    if (packageNameController.text.isNotEmpty) {
      buffer.writeln('package ${packageNameController.text};\n');
    }

    _writeImports(buffer);

    while (classStack.isNotEmpty) {
      final currentClass = classStack.removeLast();
      if (classes.containsKey(currentClass.name)) continue;
      classes[currentClass.name] = currentClass.data;
      _generateClass(
        currentClass.name,
        currentClass.data,
        buffer,
        classes,
        classStack,
      );
      buffer.writeln();
    }
    return buffer.toString().trim();
  }

  void _generateClass(
    String className,
    Map<String, dynamic> jsonData,
    StringBuffer buffer,
    Map<String, Map<String, dynamic>> classes,
    List<ClassInfo> classStack,
  ) {
    if (useLombok.value) {
      buffer.writeln('@Data');
      buffer.writeln('@Builder');
      buffer.writeln('@NoArgsConstructor');
      buffer.writeln('@AllArgsConstructor');
    }

    buffer.writeln('public class $className {');
    buffer.writeln();

    List<JavaFieldInfo> fields = _parseFields(
      jsonData,
      classes,
      classStack,
      className,
    );

    for (var field in fields) {
      _writeField(field, buffer);
    }

    if (!useLombok.value) {
      if (generateGetterSetter.value) {
        for (var field in fields) {
          _writeGetterSetter(field, buffer);
        }
      }
      if (generateBuilder.value) {
        _writeBuilder(className, fields, buffer);
      }
      if (generateToString.value) {
        _writeToString(className, fields, buffer);
      }
    }

    buffer.writeln('}');
  }

  List<JavaFieldInfo> _parseFields(
    Map<String, dynamic> data,
    Map<String, Map<String, dynamic>> classes,
    List<ClassInfo> classStack,
    String parentClassName,
  ) {
    return data.entries.map((entry) {
      final jsonKey = entry.key;
      final value = entry.value;
      final fieldName = _convertToJavaFieldName(jsonKey);

      if (value is Map<String, dynamic>) {
        final nestedClassName = _sanitizeClassName(
          '$parentClassName${_capitalize(jsonKey)}',
        );
        classStack.add(ClassInfo(nestedClassName, value));
        return JavaFieldInfo(
          name: fieldName,
          type: nestedClassName,
          jsonKey: jsonKey,
          isOptional: false,
          isCustomType: true,
        );
      } else if (value is List) {
        String typeStr = 'List<Object>';
        bool isCustom = false;
        if (value.isNotEmpty) {
          final first = value.first;
          if (first is Map<String, dynamic>) {
            final itemClassName = _sanitizeClassName(
              '$parentClassName${_capitalize(jsonKey)}Item',
            );
            classStack.add(ClassInfo(itemClassName, first));
            typeStr = 'List<$itemClassName>';
            isCustom = true;
          } else {
            final elementType =
                _javaTypeMap[first.runtimeType.toString()]?.type ?? 'Object';
            typeStr = 'List<$elementType>';
          }
        }
        return JavaFieldInfo(
          name: fieldName,
          type: typeStr,
          jsonKey: jsonKey,
          isOptional: value.isEmpty,
          isCustomType: isCustom,
        );
      }

      final typeInfo = _resolveType(value, jsonKey, classes, parentClassName);
      return JavaFieldInfo(
        name: fieldName,
        type: typeInfo.type,
        jsonKey: jsonKey,
        isOptional: value == null,
        isCustomType: typeInfo.isCustomType,
      );
    }).toList();
  }

  void _writeImports(StringBuffer buffer) {
    buffer.writeln('import java.util.List;');
    if (useOptional.value) {
      buffer.writeln('import java.util.Optional;');
    }
    buffer.writeln('import com.google.gson.annotations.SerializedName;');
    if (useLombok.value) {
      buffer.writeln('import lombok.Data;');
      buffer.writeln('import lombok.Builder;');
      buffer.writeln('import lombok.NoArgsConstructor;');
      buffer.writeln('import lombok.AllArgsConstructor;');
    }
    buffer.writeln();
  }

  void _writeField(JavaFieldInfo field, StringBuffer buffer) {
    buffer.writeln('    @SerializedName("${field.jsonKey}")');
    if (field.isOptional && useOptional.value) {
      buffer.writeln('    private Optional<${field.type}> ${field.name};');
    } else {
      buffer.writeln('    private ${field.type} ${field.name};');
    }
  }

  void _writeGetterSetter(JavaFieldInfo field, StringBuffer buffer) {
    final capitalizedField =
        field.name[0].toUpperCase() + field.name.substring(1);

    buffer.writeln();
    buffer.writeln('    public ${field.type} get$capitalizedField() {');
    if (field.isOptional && useOptional.value) {
      buffer.writeln('        return Optional.ofNullable(${field.name});');
    } else {
      buffer.writeln('        return ${field.name};');
    }
    buffer.writeln('    }');

    buffer.writeln();
    buffer.writeln(
      '    public void set$capitalizedField(${field.type} ${field.name}) {',
    );
    buffer.writeln('        this.${field.name} = ${field.name};');
    buffer.writeln('    }');
  }

  void _writeBuilder(
    String className,
    List<JavaFieldInfo> fields,
    StringBuffer buffer,
  ) {
    buffer.writeln();
    buffer.writeln('    public static class ${className}Builder {');
    for (var field in fields) {
      buffer.writeln('        private ${field.type} ${field.name};');
    }
    buffer.writeln();
    for (var field in fields) {
      buffer.writeln(
        '        public ${className}Builder ${field.name}(${field.type} ${field.name}) {',
      );
      buffer.writeln('            this.${field.name} = ${field.name};');
      buffer.writeln('            return this;');
      buffer.writeln('        }');
      buffer.writeln();
    }
    buffer.writeln('        public $className build() {');
    buffer.write('            return new $className(');
    buffer.write(fields.map((f) => f.name).join(', '));
    buffer.writeln(');');
    buffer.writeln('        }');
    buffer.writeln('    }');
    buffer.writeln();
    buffer.writeln('    public static ${className}Builder builder() {');
    buffer.writeln('        return new ${className}Builder();');
    buffer.writeln('    }');
  }

  void _writeToString(
    String className,
    List<JavaFieldInfo> fields,
    StringBuffer buffer,
  ) {
    buffer.writeln();
    buffer.writeln('    @Override');
    buffer.writeln('    public String toString() {');
    buffer.write('        return "$className{" +');
    for (int i = 0; i < fields.length; i++) {
      final field = fields[i];
      if (i == 0) {
        buffer.writeln();
        buffer.write('            "${field.name}=" + ${field.name}');
      } else {
        buffer.writeln(' +');
        buffer.write('            ", ${field.name}=" + ${field.name}');
      }
    }
    buffer.writeln(' +');
    buffer.writeln('            "}";');
    buffer.writeln('    }');
  }

  void formatJson() {
    try {
      if (jsonController.text.trim().isEmpty) return;
      final parsedJson = json.decode(jsonController.text);
      jsonController.text = const JsonEncoder.withIndent(
        '  ',
      ).convert(parsedJson);
    } catch (e) {
      _jsonConvertWarning();
    }
  }

  String _convertToJavaFieldName(String name) {
    final words = name.split(RegExp(r'[_\-]'));
    final camel =
        words.first + words.skip(1).map((word) => _capitalize(word)).join();
    // 保证首字母小写
    return camel[0].toLowerCase() + camel.substring(1);
  }

  String _capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }

  String _sanitizeClassName(String name) {
    // 去除非法字符，首字母大写
    final valid = name.replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '');
    return _capitalize(valid);
  }

  JavaTypeInfo _resolveType(
    dynamic value,
    String key,
    Map<String, Map<String, dynamic>> classes,
    String parentClassName,
  ) {
    if (value == null) {
      return JavaTypeInfo(type: 'Object', isCustomType: false);
    }
    if (value is Map) {
      final className = _sanitizeClassName(
        '$parentClassName${_capitalize(key)}',
      );
      return JavaTypeInfo(type: className, isCustomType: true);
    }
    if (value is List) {
      if (value.isEmpty) {
        return JavaTypeInfo(type: 'List<Object>', isCustomType: false);
      }
      final firstElement = value.first;
      if (firstElement is Map) {
        final itemClassName = _sanitizeClassName(
          '$parentClassName${_capitalize(key)}Item',
        );
        return JavaTypeInfo(type: 'List<$itemClassName>', isCustomType: true);
      }
      final elementType =
          _javaTypeMap[firstElement.runtimeType.toString()]?.type ?? 'Object';
      return JavaTypeInfo(type: 'List<$elementType>', isCustomType: false);
    }
    // int/double区分
    if (value is int) {
      return JavaTypeInfo(type: _javaTypeMap['int']!.type, isCustomType: false);
    }
    if (value is double) {
      return JavaTypeInfo(
        type: _javaTypeMap['double']!.type,
        isCustomType: false,
      );
    }
    if (value is bool) {
      return JavaTypeInfo(
        type: _javaTypeMap['bool']!.type,
        isCustomType: false,
      );
    }
    if (value is String) {
      return JavaTypeInfo(
        type: _javaTypeMap['String']!.type,
        isCustomType: false,
      );
    }
    return JavaTypeInfo(type: 'Object', isCustomType: false);
  }

  void _jsonConvertWarning() {
    javaCode.value = '';
    if (jsonController.text.trim().isNotEmpty) {
      MessageUtil.showError(
        title: l10n.conversionError,
        content: l10n.enterValidJsonPrompt,
      );
    }
  }

  void addToHistory() async {
    if (jsonController.text.trim().isEmpty ||
        classNameController.text.trim().isEmpty ||
        javaCode.value.isEmpty) {
      return;
    }
    final newItem = HistoryItem(
      title: classNameController.text,
      subtitle: DateTime.now().toString().substring(0, 10),
      json: jsonController.text,
      code: javaCode.value,
      timestamp: DateTime.now(),
    );
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getStringList(javaHistoryKey) ?? [];
    historyJson.add(jsonEncode(newItem.toJson()));
    await prefs.setStringList(javaHistoryKey, historyJson);
    history.add(newItem);
    MessageUtil.showSuccess(title: l10n.operationPrompt, content: '已保存到历史记录');
  }

  void deleteOne(HistoryItem item) {
    ConfirmDialog.showConfirmDialog(
      title: l10n.confirmDelete,
      content: l10n.deleteHistoryWarning,
      onConfirm: () async {
        bool remove = history.remove(item);
        if (remove) {
          final prefs = Get.find<SharedPreferences>();
          await prefs.remove(javaHistoryKey);
          prefs.setStringList(
            javaHistoryKey,
            history.map((item) => jsonEncode(item.toJson())).toList(),
          );
        }
      },
    );
  }

  @override
  void onClose() {
    jsonController.removeListener(jsonListener);
    classNameController.removeListener(classNameListener);
    packageNameController.removeListener(packageNameListener);
    jsonController.dispose();
    classNameController.dispose();
    packageNameController.dispose();
    _jsonDebounce?.cancel();
    _classNameDebounce?.cancel();
    _packageNameDebounce?.cancel();
    super.onClose();
  }
}
