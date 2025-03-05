import 'package:get/get.dart';
import 'package:json_to_dart/config/global/app_setting.dart';
import 'package:json_to_dart/screens/splash/logic/splash_logic.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SplashLogic(), permanent: true);
    Get.put(AppSetting(), permanent: true);
  }
}
