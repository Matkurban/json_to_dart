import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageServices extends GetxService {
  Future<StorageServices> init() async {
    await Get.putAsync(() async => await SharedPreferences.getInstance());
    return this;
  }
}
