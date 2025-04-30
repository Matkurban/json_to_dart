import 'package:get/get.dart';
import 'package:json_to_dart/screens/main/main_logic.dart';
import 'package:json_to_dart/screens/setting/binding/setting_binding.dart';
import 'package:json_to_dart/screens/json/binding/json_to_dart_binding.dart';
import 'package:json_to_dart/screens/json/binding/json_to_java_binding.dart';
import 'package:json_to_dart/screens/json/binding/json_generator_binding.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MainLogic());
    JsonToDartBinding().dependencies();
    JsonToJavaBinding().dependencies();
    SettingBinding().dependencies();
    JsonGeneratorBinding().dependencies();
  }
}
