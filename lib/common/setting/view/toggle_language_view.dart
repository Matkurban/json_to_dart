import 'package:flutter/material.dart';
import 'package:json_to_dart/config/global/constant.dart';
import 'package:json_to_dart/config/theme/app_style.dart';

class ToggleLanguageView extends StatelessWidget {
  const ToggleLanguageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(l10n.selectLanguage)),
      body: ListView(padding: AppStyle.defaultPadding, children: []),
    );
  }
}
