import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:syntax_highlight/syntax_highlight.dart';

class MainLogic extends GetxController {
  ///页面控制器
  final PageController pageController = PageController();

  ///bottomNavigationBar 的当前索引
  RxInt currentIndex = 0.obs;

  ///pageController切换时触发，返回索引
  void onPageChanged(int index) => currentIndex(index);

  @override
  void onInit() async {
    super.onInit();
    await Highlighter.initialize(['dart']);
  }
}
