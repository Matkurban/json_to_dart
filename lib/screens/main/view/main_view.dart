import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:json_to_dart/screens/json/view/json_to_dart_view.dart';
import 'package:json_to_dart/screens/json/view/json_to_java_view.dart';
import 'package:json_to_dart/screens/main/logic/main_logic.dart';
import 'package:json_to_dart/screens/setting/view/setting_view.dart';
import 'package:json_to_dart/config/global/constant.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainView extends GetView<MainLogic> {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: controller.pageController,
        onPageChanged: controller.onPageChanged,
        children: [JsonToDartView(), JsonToJavaView(), SettingView()],
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
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.dartLang, size: 18),
              label: l10n.dart,
            ),
            BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.java), label: l10n.java),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: l10n.settings),
          ],
        );
      }),
      floatingActionButton: TextButton(
        onPressed: () => launchUrl(Uri.parse('https://beian.miit.gov.cn')),
        child: Text('新ICP备2023004640号'),
      ),
    );
  }
}
