import 'package:flutter/material.dart';
import 'package:json_to_dart/config/theme/app_style.dart';
import 'package:syntax_highlight/syntax_highlight.dart';

class HighlightText extends StatelessWidget {
  const HighlightText({
    super.key,
    required this.codeText,
    required this.highlighter,
  });

  final String codeText;

  final Highlighter highlighter;

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: Text.rich(
        highlighter.highlight(codeText),
        style: AppStyle.codeTextStyle,
        textAlign: TextAlign.start,
      ),
    );
  }
}
