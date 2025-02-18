import 'package:get/get.dart';
import 'package:json_to_dart/model/domain/main/router_item.dart';
import 'package:json_to_dart/router/router_names.dart';

class HomeLogic extends GetxController {
  ///已有的功能
  final List<RouterItem> commonList = <RouterItem>[
    RouterItem(name: 'Json转Dart类', router: RouterNames.jsonToDart),
  ];
}
