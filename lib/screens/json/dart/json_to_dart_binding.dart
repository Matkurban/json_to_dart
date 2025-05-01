import 'package:get/get.dart';
import 'package:json_to_dart/screens/json/dart/json_to_dart_logic.dart';

class JsonToDartBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(JsonToDartLogic());
  }
}
