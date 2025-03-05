import 'package:get/get.dart';
import 'package:json_to_dart/screens/json/logic/json_to_java_logic.dart';

class JsonToJavaBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(JsonToJavaLogic());
  }
}
