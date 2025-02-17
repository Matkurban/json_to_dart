import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:json_to_dart/common/main/logic/main_logic.dart';
import 'package:json_to_dart/config/theme/app_style.dart';
import 'package:json_to_dart/widgets/button/custom_text_button.dart';

class MainView extends GetView<MainLogic> {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      body: GridView.builder(
        padding: AppStyle.defaultPadding,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount:
              (screenWidth / 300).floor() < 2 ? 2 : (screenWidth / 300).floor(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          mainAxisExtent: 60,
        ),
        itemBuilder: (context, index) {
          var routerItem = controller.commonList[index];
          return CustomTextButton(
            text: routerItem.name,
            onPress: () => Get.toNamed(routerItem.router),
          );
        },
        itemCount: controller.commonList.length,
      ),
    );
  }
}
