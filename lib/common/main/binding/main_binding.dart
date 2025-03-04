import 'package:get/get.dart';
import 'package:json_to_dart/common/json/binding/json_to_dart_binding.dart';
import 'package:json_to_dart/common/json/binding/json_to_java_binding.dart';
import 'package:json_to_dart/common/main/logic/main_logic.dart';
import 'package:json_to_dart/common/setting/binding/setting_binding.dart';
import 'package:json_to_dart/config/global/app_setting.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AppSetting(), permanent: true);
    Get.put(MainLogic());
    JsonToDartBinding().dependencies();
    JsonToJavaBinding().dependencies();
    SettingBinding().dependencies();
  }
}
