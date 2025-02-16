import 'package:get/get.dart';
import 'package:json_to_dart/json/logic/json_converter_logic.dart';

class JsonConverterBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(JsonConverterLogic());
  }
}
