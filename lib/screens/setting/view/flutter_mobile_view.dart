import 'package:flutter/material.dart';
import 'package:json_to_dart/config/global/constant.dart';
import 'package:webview_all/webview_all.dart';

class FlutterMobileView extends StatelessWidget {
  const FlutterMobileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(l10n.flutterMobileMirrorConfig)),
      body: Center(
        child: Webview(
          url:
              'http://111.170.172.97:8090/archives/flutter-android-guo-nei-gou-jian-zhi-nan',
          appName: 'json_to_dart',
        ),
      ),
    );
  }
}
