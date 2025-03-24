import 'package:flutter/material.dart';
import 'package:json_to_dart/config/global/constant.dart';
import 'package:webview_all/webview_all.dart';

class StudioTemplateView extends StatelessWidget {
  const StudioTemplateView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.androidStudioDartTemplate),
      ),
      body: Center(
        child: Webview(
          url:
              'http://111.170.172.97:8090/archives/androidstudio-chuang-jian-dart-wen-jian-mo-ban',
          appName: 'json_to_dart',
        ),
      ),
    );
  }
}
