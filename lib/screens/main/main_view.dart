import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:json_to_dart/config/global/constant.dart';
import 'package:json_to_dart/config/assets/image_assets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:json_to_dart/screens/main/main_logic.dart';
import 'package:json_to_dart/screens/setting/view/setting_view.dart';
import 'package:json_to_dart/screens/json/dart/json_to_dart_view.dart';
import 'package:json_to_dart/screens/json/java/json_to_java_view.dart';
import 'package:json_to_dart/screens/json/generator/json_generator_view.dart';

class MainView extends GetView<MainLogic> {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Row(
        children: [
          Obx(() {
            return NavigationRail(
              leading: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Image(
                  image: AssetImage(ImageAssets.logo),
                  width: 48,
                  height: 48,
                ),
              ),
              destinations: [
                NavigationRailDestination(
                  icon: Icon(FontAwesomeIcons.font),
                  selectedIcon: FaIcon(
                    FontAwesomeIcons.font,
                    color: colorScheme.primary,
                  ),
                  label: Text(l10n.jsonGenerator),
                ),
                NavigationRailDestination(
                  icon: Icon(FontAwesomeIcons.dartLang),
                  selectedIcon: FaIcon(
                    FontAwesomeIcons.dartLang,
                    color: colorScheme.primary,
                  ),
                  label: Text(l10n.dart),
                ),
                NavigationRailDestination(
                  icon: FaIcon(FontAwesomeIcons.java),
                  selectedIcon: FaIcon(
                    FontAwesomeIcons.java,
                    color: colorScheme.primary,
                  ),
                  label: Text(l10n.java),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.settings),
                  selectedIcon: Icon(
                    Icons.settings,
                    color: colorScheme.primary,
                  ),
                  label: Text(l10n.settings),
                ),
              ],
              selectedIndex: controller.currentIndex.value,
              onDestinationSelected: (value) {
                controller.pageController.animateToPage(
                  value,
                  duration: Duration(milliseconds: 200),
                  curve: Curves.bounceIn,
                );
              },
            );
          }),
          Expanded(
            child: PageView(
              controller: controller.pageController,
              onPageChanged: controller.onPageChanged,
              children: [
                JsonGeneratorView(),
                JsonToDartView(),
                JsonToJavaView(),
                SettingView(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: TextButton(
        onPressed: () => launchUrl(Uri.parse('https://beian.miit.gov.cn')),
        child: Text('新ICP备2023004640号'),
      ),
    );
  }
}
