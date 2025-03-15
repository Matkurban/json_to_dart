import 'package:get/get.dart';
import 'package:json_to_dart/config/assets/markdown_assets.dart';
import 'package:json_to_dart/utils/file_util.dart';

class StudioTemplateLogic extends GetxController with StateMixin<String> {
  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  void loadData() async {
    change('', status: RxStatus.loading());
    try {
      String data = await FileUtil.readAsset(MarkdownAssets.studioTemplate);
      change(data, status: RxStatus.success());
    } catch (e) {
      change('', status: RxStatus.error());
    }
  }
}
