import 'package:get/get.dart';
import 'package:json_to_dart/common/main/logic/main_logic.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MainLogic());
  }
}
