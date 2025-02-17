// lib/main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:json_to_dart/common/main/binding/main_binding.dart';
import 'package:json_to_dart/common/main/view/main_view.dart';
import 'package:json_to_dart/config/theme/app_theme.dart';
import 'package:json_to_dart/router/router_pages.dart';
import 'package:json_to_dart/services/storage_services.dart';

void main() async {
  await initServices();
  runApp(const JsonToDartApp());
}

Future<void> initServices() async {
  await Get.putAsync(() => StorageServices().init());
}

class JsonToDartApp extends StatelessWidget {
  const JsonToDartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '高级JSON转换工具',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: MainView(),
      initialBinding: MainBinding(),
      debugShowCheckedModeBanner: false,
      getPages: RouterPages.allPages(),
    );
  }
}
