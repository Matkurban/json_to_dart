import 'package:flutter/widgets.dart';
import 'package:syntax_highlight/syntax_highlight.dart';

class HighlightText extends StatelessWidget {
  const HighlightText({super.key, required this.codeText, required this.highlighter});

  final String codeText;

  final Highlighter highlighter;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      highlighter.highlight(codeText),
      style: TextStyle(
        fontFamily: "JetBrainsMono",
        fontSize: 16,
        height: 1.2,
      ),
    );
  }
}
