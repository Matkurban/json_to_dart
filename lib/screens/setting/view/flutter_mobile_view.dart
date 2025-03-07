import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:json_to_dart/screens/setting/logic/flutter_mobile_logic.dart';
import 'package:json_to_dart/screens/setting/widgets/load_empty.dart';
import 'package:json_to_dart/screens/setting/widgets/load_error.dart';
import 'package:json_to_dart/screens/setting/widgets/loading.dart';
import 'package:json_to_dart/config/theme/app_style.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:flutter_highlight/themes/a11y-light.dart';
import 'package:url_launcher/url_launcher.dart';

class FlutterMobileView extends GetView<FlutterMobileLogic> {
  const FlutterMobileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flutter 移动端镜像配置')),
      body: Padding(
        padding: AppStyle.defaultPadding,
        child: controller.obx(
          (data) {
            final tocController = TocController();
            return FadeIn(
              child: Row(
                children: [
                  Expanded(
                    flex: 7,
                    child: MarkdownWidget(
                      data: data ?? "",
                      tocController: tocController,
                      config: MarkdownConfig(
                        configs: [
                          PreConfig(theme: a11yLightTheme),
                          LinkConfig(
                            onTap: (url) async {
                              if (await canLaunchUrl(Uri.parse(url))) {
                                launchUrl(Uri.parse(url));
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(flex: 3, child: TocWidget(controller: tocController)),
                ],
              ),
            );
          },
          onEmpty: LoadEmpty(),
          onError: (error) => LoadError(),
          onLoading: Loading(),
        ),
      ),
    );
  }
}
