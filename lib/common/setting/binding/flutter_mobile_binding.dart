import 'package:get/get.dart';
import 'package:json_to_dart/common/setting/logic/flutter_mobile_logic.dart';

class FlutterMobileBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(FlutterMobileLogic());
  }
}
