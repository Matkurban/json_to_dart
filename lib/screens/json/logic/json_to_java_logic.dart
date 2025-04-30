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

  static const Map<Type, JavaType> _javaTypeMap = {
    String: JavaType('String', 'String', 'null', '""'),
    int: JavaType('Integer', 'int', '0', '0'),
    double: JavaType('Double', 'double', '0.0', '0.0'),
    bool: JavaType('Boolean', 'boolean', 'false', 'false'),
    Null: JavaType('Object', 'Object', 'null', 'null'),
  };

  Timer? _jsonDebounce;
  Timer? _classNameDebounce;
  Timer? _packageNameDebounce;

  @override
  void onInit() async {
    super.onInit();
    highlighter = Highlighter(
      language: 'dart',
      theme: splashLogic.highlighterTheme,
    );
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
    final classes = <String, Map<String, dynamic>>{}; // 存储所有需要生成的类
    final classStack = [
      ClassInfo(classNameController.text.trim(), jsonData),
    ]; // 用于处理嵌套类

    // Add package declaration if provided
    if (packageNameController.text.isNotEmpty) {
      buffer.writeln('package ${packageNameController.text};');
      buffer.writeln();
    }

    // Add imports
    _writeImports(buffer);

    // 处理所有嵌套类
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
    // Add Lombok annotations if enabled
    if (useLombok.value) {
      buffer.writeln('@Data');
      buffer.writeln('@Builder');
      buffer.writeln('@NoArgsConstructor');
      buffer.writeln('@AllArgsConstructor');
    }

    buffer.writeln('public class $className {');
    buffer.writeln();

    // Generate fields and collect nested classes
    List<JavaFieldInfo> fields = _parseFields(
      jsonData,
      classes,
      classStack,
      className,
    );

    for (var field in fields) {
      _writeField(field, buffer);
    }

    // Generate getters and setters if not using Lombok
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

      // Handle nested objects and arrays
      if (value is Map<String, dynamic>) {
        // 创建嵌套类的类名
        final nestedClassName = '$parentClassName${jsonKey.capitalize}';
        // 将嵌套类添加到待处理队列
        classStack.add(ClassInfo(nestedClassName, value));

        return JavaFieldInfo(
          name: fieldName,
          type: nestedClassName,
          jsonKey: jsonKey,
          isOptional: false,
          isCustomType: true,
        );
      } else if (value is List && value.isNotEmpty && value[0] is Map) {
        // 处理对象数组
        final itemClassName = '$parentClassName${jsonKey.capitalize}Item';
        classStack.add(
          ClassInfo(itemClassName, value[0] as Map<String, dynamic>),
        );

        return JavaFieldInfo(
          name: fieldName,
          type: 'List<$itemClassName>',
          jsonKey: jsonKey,
          isOptional: false,
          isCustomType: true,
        );
      }

      // 处理基本类型
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

    // Generate getter
    buffer.writeln();
    buffer.writeln('    public ${field.type} get$capitalizedField() {');
    if (field.isOptional && useOptional.value) {
      buffer.writeln('        return Optional.ofNullable(${field.name});');
    } else {
      buffer.writeln('        return ${field.name};');
    }
    buffer.writeln('    }');

    // Generate setter
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

    // Builder fields
    for (var field in fields) {
      buffer.writeln('        private ${field.type} ${field.name};');
    }

    buffer.writeln();

    // Builder methods
    for (var field in fields) {
      buffer.writeln(
        '        public ${className}Builder ${field.name}(${field.type} ${field.name}) {',
      );
      buffer.writeln('            this.${field.name} = ${field.name};');
      buffer.writeln('            return this;');
      buffer.writeln('        }');
      buffer.writeln();
    }

    // Build method
    buffer.writeln('        public $className build() {');
    buffer.write('            return new $className(');
    buffer.write(fields.map((f) => f.name).join(', '));
    buffer.writeln(');');
    buffer.writeln('        }');
    buffer.writeln('    }');

    // Static builder creator method
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
    // Convert snake_case or kebab-case to camelCase
    final words = name.split(RegExp(r'[_\-]'));
    return words.first + words.skip(1).map((word) => word.capitalize!).join();
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
      final className = '$parentClassName${key.capitalize}';
      return JavaTypeInfo(type: className, isCustomType: true);
    }

    if (value is List) {
      if (value.isEmpty) {
        return JavaTypeInfo(type: 'List<Object>', isCustomType: false);
      }
      final firstElement = value.first;
      if (firstElement is Map) {
        final itemClassName = '$parentClassName${key.capitalize}Item';
        return JavaTypeInfo(type: 'List<$itemClassName>', isCustomType: true);
      }
      final elementType =
          _javaTypeMap[firstElement.runtimeType]?.type ?? 'Object';
      return JavaTypeInfo(type: 'List<$elementType>', isCustomType: false);
    }

    final javaType = _javaTypeMap[value.runtimeType] ?? _javaTypeMap[Null]!;
    return JavaTypeInfo(type: javaType.type, isCustomType: false);
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

  // 在 JsonToJavaLogic 类中添加以下方法
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

    // 保存到 SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getStringList(javaHistoryKey) ?? [];
    historyJson.add(jsonEncode(newItem.toJson()));
    await prefs.setStringList(javaHistoryKey, historyJson);

    // 更新历史记录列表
    history.add(newItem);
    MessageUtil.showSuccess(title: l10n.operationPrompt, content: '已保存到历史记录');
  }


  ///删除单个历史记录
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
    jsonController.dispose();
    classNameController.dispose();
    packageNameController.dispose();
    _jsonDebounce?.cancel();
    _classNameDebounce?.cancel();
    _packageNameDebounce?.cancel();
    super.onClose();
  }
}
