import 'package:get/get.dart';
import 'package:json_to_dart/screens/tools/permutation/permutation_logic.dart';

class PermutationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PermutationLogic());
  }
}
