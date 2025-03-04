import 'package:get/get.dart';
import 'package:json_to_dart/common/setting/logic/setting_logic.dart';

class SettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SettingLogic());
  }
}
