import 'package:get/get.dart';
import 'package:json_to_dart/config/assets/assets_markdown.dart';
import 'package:json_to_dart/utils/file_util.dart';

class FlutterMobileLogic extends GetxController {
  final RxString markdownData = ''.obs;

  @override
  void onInit() {
    super.onInit();
    FileUtil.readAsset(AssetsMarkdown.flutterMobile).then((value) => markdownData(value));
  }
}
