import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:json_to_dart/common/setting/logic/flutter_mobile_logic.dart';
import 'package:url_launcher/url_launcher.dart';

class FlutterMobileView extends GetView<FlutterMobileLogic> {
  const FlutterMobileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flutter 移动端镜像配置')),
      body: Obx(() {
        return Markdown(
          data: controller.markdownData.value,
          selectable: true,
          onTapLink: (String text, String? href, String title) {
            if (href != null && Uri.tryParse(href) != null) {
              launchUrl(Uri.parse(href));
            }
          },
        );
      }),
    );
  }
}
