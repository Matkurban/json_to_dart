import 'package:get/get.dart';
import 'package:json_to_dart/screens/json/generator/json_generator_logic.dart';

class JsonGeneratorBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<JsonGeneratorLogic>(JsonGeneratorLogic());
  }
}
