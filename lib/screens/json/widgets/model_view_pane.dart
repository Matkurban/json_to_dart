import 'package:flutter/material.dart';
import 'package:json_to_dart/config/global/constant.dart';
import 'package:json_to_dart/config/theme/app_style.dart';
import 'package:json_to_dart/widgets/highlight/highlight_text.dart';
import 'package:syntax_highlight/syntax_highlight.dart';

class ModelViewPane extends StatelessWidget {
  const ModelViewPane({super.key, required this.code, required this.highlighter});

  final String code;
  final Highlighter highlighter;

  @override
  Widget build(BuildContext context) {
    if (code.isEmpty) {
      return Center(child: Text(l10n.generateDartHint));
    }
    return Padding(
      padding: AppStyle.defaultPadding,
      child: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: HighlightText(codeText: code, highlighter: highlighter),
        ),
      ),
    );
  }
}
