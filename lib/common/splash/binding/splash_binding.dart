import 'package:get/get.dart';
import 'package:json_to_dart/common/splash/logic/splash_logic.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SplashLogic());
  }
}
