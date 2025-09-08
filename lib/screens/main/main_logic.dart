import 'package:get/get.dart';
import 'package:flutter/material.dart' show PageController;

class MainLogic extends GetxController {
  ///页面控制器
  final PageController pageController = PageController();

  ///bottomNavigationBar 的当前索引
  RxInt currentIndex = 0.obs;

  ///pageController切换时触发，返回索引
  void onPageChanged(int index) => currentIndex(index);

  ///是否展开
  RxBool isExtended = false.obs;
}
