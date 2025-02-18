import 'package:get/get.dart';
import 'package:json_to_dart/common/json/binding/json_to_dart_binding.dart';
import 'package:json_to_dart/common/json/view/json_to_dart_view.dart';
import 'package:json_to_dart/router/router_names.dart';

sealed class RouterPages {
  static List<GetPage> allPages() {
    return [
      GetPage(
        name: RouterNames.jsonToDart,
        page: () => JsonToDartView(),
        binding: JsonToDartBinding(),
      ),
    ];
  }
}
