import 'package:get/get.dart';
import 'package:json_to_dart/screens/main/main_logic.dart';
import 'package:json_to_dart/screens/setting/binding/setting_binding.dart';
import 'package:json_to_dart/screens/json/dart/json_to_dart_binding.dart';
import 'package:json_to_dart/screens/json/java/json_to_java_binding.dart';
import 'package:json_to_dart/screens/json/generator/json_generator_binding.dart';
import 'package:json_to_dart/screens/tools/permutation/permutation_binding.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MainLogic());
    JsonToDartBinding().dependencies();
    JsonToJavaBinding().dependencies();
    SettingBinding().dependencies();
    JsonGeneratorBinding().dependencies();
    PermutationBinding().dependencies();
  }
}
