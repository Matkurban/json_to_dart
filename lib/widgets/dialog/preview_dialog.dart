import 'package:flutter/material.dart';
import 'package:flutter_json_view/flutter_json_view.dart';
import 'package:get/get.dart';
import 'package:json_to_dart/screens/json/logic/json_to_dart_logic.dart';
import 'package:json_to_dart/config/global/constant.dart';
import 'package:json_to_dart/config/theme/app_style.dart';
import 'package:json_to_dart/model/domain/main/history_item.dart';
import 'package:json_to_dart/widgets/highlight/highlight_text.dart';

sealed class PreviewDialog {
  static void showPreviewDialog(BuildContext context, HistoryItem item) {
    showDialog(
      context: context,
      builder: (context) => _PreviewDialogContent(item: item),
    );
  }

  static void showPreviewJsonDialog(BuildContext context, String json) {
    var size = MediaQuery.sizeOf(context);
    var themeData = Theme.of(context);
    var colorScheme = themeData.colorScheme;
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: themeData.cardColor,
          child: Container(
            padding: AppStyle.defaultPadding,
            constraints: BoxConstraints(
              maxWidth: size.width * 0.9,
              maxHeight: size.height * 0.9,
              minHeight: size.height * 0.9,
            ),
            child: SingleChildScrollView(
              child: JsonView.string(
                json,
                theme: JsonViewTheme(
                  defaultTextStyle: TextStyle(fontFamily: "JetBrainsMono"),
                  viewType: JsonViewType.collapsible,
                  keyStyle: TextStyle(color: colorScheme.primary),
                  doubleStyle: TextStyle(color: colorScheme.secondary),
                  intStyle: TextStyle(color: colorScheme.secondary),
                  boolStyle: TextStyle(color: colorScheme.secondary),
                  stringStyle: TextStyle(color: colorScheme.secondary),
                  closeIcon: Icon(Icons.keyboard_arrow_down, size: 16),
                  openIcon: Icon(Icons.keyboard_arrow_up, size: 16),
                  separator: Text(':'),
                  backgroundColor: Colors.transparent,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static void showPreviewDartDialog(BuildContext context, Widget child) {
    var size = MediaQuery.sizeOf(context);
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: size.width * 0.9,
              maxHeight: size.height * 0.9,
              minHeight: size.height * 0.9,
            ),
            child: child,
          ),
        );
      },
    );
  }
}

class _PreviewDialogContent extends GetView<JsonToDartLogic> {
  final HistoryItem item;

  const _PreviewDialogContent({required this.item});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    return Dialog(
      child: Container(
        padding: AppStyle.defaultPadding,
        constraints: BoxConstraints(
          maxWidth: size.width * 0.9,
          maxHeight: size.height * 0.9,
        ),
        child: Row(
          spacing: 10,
          children: [
            _buildCodeCard(
              title: 'JSON',
              content: item.json,
              onCopy: () => copyToClipboard(item.json),
              tooltip: l10n.copyJson,
            ),
            _buildCodeCard(
              title: 'Dart',
              content: item.code,
              onCopy: () => copyToClipboard(item.code),
              tooltip: l10n.copyCode,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCodeCard({
    required String title,
    required String content,
    required VoidCallback onCopy,
    String? tooltip,
  }) {
    return Expanded(
      child: Card(
        elevation: 0,
        margin: EdgeInsets.zero,
        child: Padding(
          padding: AppStyle.defaultPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            spacing: 10,
            children: [
              // 标题栏
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy),
                    onPressed: onCopy,
                    tooltip: tooltip,
                  ),
                ],
              ),
              // 代码内容区域
              Expanded(
                child: LayoutBuilder(
                  builder: (context, con) {
                    return SingleChildScrollView(
                      child: SizedBox(
                        width: con.maxWidth,
                        child: HighlightText(
                          codeText: content,
                          highlighter: controller.highlighter,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
