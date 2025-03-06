import 'package:flutter/material.dart';
import 'package:fluent_ui/fluent_ui.dart'
    show TreeView, TreeViewItem, FluentTheme, FluentThemeData, TreeViewSelectionMode;
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:json_to_dart/widgets/markdown/styled_markdown_widget.dart';
import 'package:markdown/markdown.dart' as md;

class HeadingItem {
  final String text;
  final int level;
  final String anchor;
  final GlobalKey key = GlobalKey();

  HeadingItem({required this.text, required this.level, required this.anchor});
}

class MarkdownPreviewPage extends StatefulWidget {
  final String markdownContent;

  const MarkdownPreviewPage({super.key, required this.markdownContent});

  @override
  State<MarkdownPreviewPage> createState() => _MarkdownPreviewPageState();
}

class _MarkdownPreviewPageState extends State<MarkdownPreviewPage> {
  final List<HeadingItem> _headings = [];
  final ScrollController _scrollController = ScrollController();
  String? _selectedAnchor;

  @override
  void initState() {
    super.initState();
    _parseHeadings();
  }

  void _parseHeadings() {
    _headings.clear();

    // 使用正则表达式匹配标题
    final headingRegExp = RegExp(r'^(#{1,6})\s+(.+)$', multiLine: true);
    final matches = headingRegExp.allMatches(widget.markdownContent);

    for (final match in matches) {
      final level = match.group(1)?.length ?? 0;
      final text = match.group(2)?.trim() ?? '';

      if (level > 0 && text.isNotEmpty) {
        final anchor = text.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-');
        _headings.add(HeadingItem(text: text, level: level, anchor: anchor));
      }
    }
  }

  void _scrollToHeading(HeadingItem heading) {
    setState(() {
      _selectedAnchor = heading.anchor;
    });

    if (heading.key.currentContext != null) {
      Scrollable.ensureVisible(
        heading.key.currentContext!,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  List<TreeViewItem> _buildTreeStructure() {
    if (_headings.isEmpty) return [];

    final List<TreeViewItem> result = [];
    Map<int, TreeViewItem> lastItemAtLevel = {};

    for (final heading in _headings) {
      final TreeViewItem newItem = TreeViewItem(
        content: Text(
          heading.text,
          style: TextStyle(color: _selectedAnchor == heading.anchor ? Colors.blue : null),
        ),
        onInvoked: (item, reason) async => _scrollToHeading(heading),
        collapsable: false,
        expanded: true,
      );

      if (heading.level == 1) {
        // 一级标题直接加入结果列表
        result.add(newItem);
        lastItemAtLevel[1] = newItem;
      } else {
        // 找到上一级标题
        for (int i = heading.level - 1; i >= 1; i--) {
          if (lastItemAtLevel.containsKey(i)) {
            // 获取父项的现有子项
            final parentItem = lastItemAtLevel[i]!;
            final List<TreeViewItem> currentChildren = List.from(parentItem.children);
            currentChildren.add(newItem);

            // 创建新的父项，包含更新后的子项列表
            final updatedParent = TreeViewItem(
              content: parentItem.content,
              onInvoked: parentItem.onInvoked,
              children: currentChildren,
              collapsable: true,
              expanded: true,
            );

            // 更新父项
            if (i == 1) {
              final index = result.indexOf(parentItem);
              if (index != -1) {
                result[index] = updatedParent;
              }
            } else {
              // 更新上一级的子项列表
              for (int j = i - 1; j >= 1; j--) {
                if (lastItemAtLevel.containsKey(j)) {
                  final upperParent = lastItemAtLevel[j]!;
                  final upperChildren = List<TreeViewItem>.from(upperParent.children);
                  final indexToUpdate = upperChildren.indexOf(parentItem);
                  if (indexToUpdate != -1) {
                    upperChildren[indexToUpdate] = updatedParent;
                    lastItemAtLevel[j] = TreeViewItem(
                      content: upperParent.content,
                      onInvoked: upperParent.onInvoked,
                      children: upperChildren,
                      collapsable: true,
                      expanded: true,
                    );
                  }
                }
              }
            }
            lastItemAtLevel[i] = updatedParent;
            break;
          }
        }
        lastItemAtLevel[heading.level] = newItem;
      }
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // 右侧 Markdown 内容
          Expanded(
            flex: 7,
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: MarkdownBody(
                  data: widget.markdownContent,
                  selectable: true,
                  builders: {
                    'code': CodeElementBuilder(),
                    'h1': _HeadingBuilder(level: 1, headings: _headings),
                    'h2': _HeadingBuilder(level: 2, headings: _headings),
                    'h3': _HeadingBuilder(level: 3, headings: _headings),
                    'h4': _HeadingBuilder(level: 4, headings: _headings),
                    'h5': _HeadingBuilder(level: 5, headings: _headings),
                    'h6': _HeadingBuilder(level: 6, headings: _headings),
                  },
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                border: BorderDirectional(end: BorderSide(color: Colors.grey, width: 0.5)),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('目录', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                    child: FluentTheme(
                      data: FluentThemeData(),
                      child: TreeView(
                        items: _buildTreeStructure(),
                        shrinkWrap: true,
                        selectionMode: TreeViewSelectionMode.single,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeadingBuilder extends MarkdownElementBuilder {
  final int level;
  final List<HeadingItem> headings;

  _HeadingBuilder({required this.level, required this.headings});

  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    final text = element.textContent;
    final anchor = text.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-');

    // 查找对应的 HeadingItem
    final headingItem = headings.firstWhere(
      (item) => item.anchor == anchor && item.level == level,
      orElse: () => HeadingItem(text: text, level: level, anchor: anchor),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        key: headingItem.key,
        style: TextStyle(fontSize: 24 - (level - 1) * 2.0, fontWeight: FontWeight.bold),
      ),
    );
  }
}
