import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:json_to_dart/common/json/view/json_to_dart_view.dart';
import 'package:json_to_dart/common/main/logic/main_logic.dart';
import 'package:json_to_dart/common/setting/view/setting_view.dart';

class MainView extends GetView<MainLogic> {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: controller.pageController,
        onPageChanged: controller.onPageChanged,
        children: [JsonToDartView(), SettingView()],
      ),
      bottomNavigationBar: Obx(() {
        return BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap:
              (value) => controller.pageController.animateToPage(
                value,
                duration: Duration(milliseconds: 200),
                curve: Curves.bounceIn,
              ),
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: '首页'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: '设置'),
          ],
        );
      }),
    );
  }
}
