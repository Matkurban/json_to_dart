import 'package:get/get.dart';
import 'package:json_to_dart/common/json/logic/json_to_model_logic.dart';

class JsonToDartBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(JsonToModelLogic());
  }
}
