import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:json_to_dart/screens/json/dart/json_to_dart_logic.dart';
import 'package:json_to_dart/config/global/constant.dart';
import 'package:json_to_dart/config/theme/app_style.dart';
import 'package:json_to_dart/model/domain/main/history_item.dart';
import 'package:json_to_dart/screens/json/widgets/model_view_pane.dart';
import 'package:json_to_dart/screens/splash/logic/splash_logic.dart';
import 'package:json_to_dart/widgets/highlight/highlight_text.dart';
import 'package:kurban_json_viewer/kurban_json_viewer.dart';
import 'package:syntax_highlight/syntax_highlight.dart';

sealed class PreviewDialog {
  static void showPreviewDialog(BuildContext context, HistoryItem item) {
    showDialog(
      context: context,
      builder: (context) => _PreviewDialogContent(item: item),
    );
  }

  static void showPreviewJsonDialog(BuildContext context, Map<String, dynamic> json) {
    var size = MediaQuery.sizeOf(context);
    var themeData = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) {
        return ZoomIn(
          child: Dialog(
            backgroundColor: themeData.cardColor,
            child: Container(
              width: size.width * 0.8,
              padding: AppStyle.defaultPadding,
              constraints: BoxConstraints(
                maxWidth: size.width * 0.8,
                maxHeight: size.height * 0.8,
                minHeight: size.height * 0.8,
              ),
              child: JsonViewer(jsonData: json),
            ),
          ),
        );
      },
    );
  }

  static void showPreviewDartDialog(BuildContext context, String code) {
    var size = MediaQuery.sizeOf(context);
    SplashLogic splashLogic = Get.find<SplashLogic>();
    Highlighter highlighter = Highlighter(language: 'dart', theme: splashLogic.highlighterTheme);
    showDialog(
      context: context,
      builder: (context) {
        return ZoomIn(
          child: Dialog(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: size.width * 0.9,
                maxHeight: size.height * 0.9,
                minHeight: size.height * 0.9,
              ),
              child: ModelViewPane(code: code, highlighter: highlighter),
            ),
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
    return ZoomIn(
      child: Dialog(
        child: Container(
          padding: AppStyle.smallPadding,
          constraints: BoxConstraints(maxWidth: size.width * 0.9, maxHeight: size.height * 0.9),
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
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  IconButton(icon: const Icon(Icons.copy), onPressed: onCopy, tooltip: tooltip),
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
