import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/github.dart';
import 'package:flutter_highlight/themes/monokai.dart';
import 'package:json_to_dart/config/global/constant.dart';

class CodeHighlightWidget extends StatelessWidget {
  final String code;
  final String? language;

  const CodeHighlightWidget({super.key, required this.code, this.language});

  Future<void> _copyToClipboard() async {
    copyToClipboard(code);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: isDarkMode ? const Color(0xFF1E1E1E) : const Color(0xFFF6F8FA),
        border: Border.all(color: isDarkMode ? Colors.grey[800]! : Colors.grey[300]!, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 头部：显示语言和复制按钮
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.black26 : Colors.black.withValues(alpha: 0.03),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              border: Border(
                bottom: BorderSide(
                  color: isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (language != null)
                  Text(
                    language!,
                    style: TextStyle(
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                IconButton(
                  onPressed: _copyToClipboard,
                  icon: Icon(Icons.copy, size: 16),
                  tooltip: l10n.copyCode,
                  constraints: BoxConstraints(maxHeight: 36, maxWidth: 36),
                ),
              ],
            ),
          ),
          // 代码内容区域
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
              child: HighlightView(
                code,
                language: language ?? 'plaintext',
                theme: isDarkMode ? monokaiTheme : githubTheme,
                padding: const EdgeInsets.all(16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
