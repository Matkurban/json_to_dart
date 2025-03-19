import 'package:get/get.dart';
import '../logic/json_generator_logic.dart';

class JsonGeneratorBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<JsonGeneratorLogic>( JsonGeneratorLogic());
  }
}
