import 'package:get/get.dart';
import 'package:json_to_dart/screens/setting/logic/studio_template_logic.dart';

class StudioTemplateBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(StudioTemplateLogic());
  }
}
