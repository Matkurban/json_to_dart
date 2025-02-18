import 'package:get/get.dart';
import 'package:json_to_dart/common/home/binding/home_binding.dart';
import 'package:json_to_dart/common/main/logic/main_logic.dart';
import 'package:json_to_dart/common/setting/binding/setting_binding.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MainLogic());
    HomeBinding().dependencies();
    SettingBinding().dependencies();
  }
}
