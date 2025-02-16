// lib/main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:json_to_dart/config/theme/app_theme.dart';
import 'package:json_to_dart/json/binding/json_converter_binding.dart';
import 'package:json_to_dart/json/view/json_converter_view.dart';

void main() => runApp(const JsonToDartApp());

class JsonToDartApp extends StatelessWidget {
  const JsonToDartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '高级JSON转换工具',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: const JsonConverterView(),
      initialBinding: JsonConverterBinding(),
      debugShowCheckedModeBanner: false,
    );
  }
}
