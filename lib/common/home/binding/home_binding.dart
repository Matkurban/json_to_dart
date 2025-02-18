import 'package:get/get.dart';
import 'package:json_to_dart/common/home/logic/home_logic.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeLogic());
  }
}
