import 'package:markdown/markdown.dart' as md;
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import 'code_highlight_widget.dart';

class StyledMarkdownWidget extends StatelessWidget {
  final String data;
  final double? maxHeight;

  const StyledMarkdownWidget({super.key, required this.data, this.maxHeight});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MarkdownBody(
      data: data,
      selectable: true,
      builders: {'code': CodeElementBuilder()},
      styleSheet: MarkdownStyleSheet(
        // 段落样式
        p: textTheme.bodyLarge?.copyWith(height: 1.5),

        // 链接样式
        a: TextStyle(color: Colors.blue),

        // 行内代码样式
        code: TextStyle(backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200]),
      ),
      onTapLink: (text, href, title) async {
        if (href != null) {
          final url = Uri.parse(href);
          if (await canLaunchUrl(url)) {
            await launchUrl(url);
          }
        }
      },
    );
  }
}

class CodeElementBuilder extends MarkdownElementBuilder {
  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    // 检查是否为内联代码
    final bool isInlineCode = element.tag == 'code' && !element.textContent.contains('\n');

    // 如果是内联代码，返回 null 以使用默认样式
    if (isInlineCode) {
      return null;
    }

    String? language;

    // 获取代码块的类名
    final classAttribute = element.attributes['class'];
    if (classAttribute != null) {
      // 如果有 language- 前缀，去掉前缀获取语言名称
      if (classAttribute.startsWith('language-')) {
        language = classAttribute.substring(9);
      } else {
        language = classAttribute;
      }
    }

    // 获取代码内容并移除多余的换行
    final code = element.children?.map((e) => e is md.Text ? e.text : '').join('').trim() ?? '';

    return CodeHighlightWidget(code: code, language: language);
  }
}
