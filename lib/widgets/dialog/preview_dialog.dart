import 'package:flutter/material.dart';
import 'package:flutter_json_view/flutter_json_view.dart';
import 'package:json_to_dart/common/json/logic/json_to_dart_logic.dart';
import 'package:json_to_dart/model/domain/dart/history_item.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:json_to_dart/utils/message_util.dart';
import 'package:json_to_dart/widgets/highlight/highlight_text.dart';

sealed class PreviewDialog {
  static void showPreviewDialog(BuildContext context, HistoryItem item) {
    showDialog(context: context, builder: (context) => _PreviewDialogContent(item: item));
  }

  static void showPreviewJsonDialog(BuildContext context, String json) {
    var size = MediaQuery.sizeOf(context);
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(10.0),
            constraints: BoxConstraints(
              maxWidth: size.width * 0.9,
              maxHeight: size.height * 0.9,
              minHeight: size.height * 0.9,
            ),
            child: SingleChildScrollView(
              child: JsonView.string(
                json,
                theme: JsonViewTheme(
                  viewType: JsonViewType.collapsible,
                  defaultTextStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black,
                  ),
                  keyStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  doubleStyle: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  intStyle: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.tertiary),
                  boolStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  stringStyle: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                  ),
                  closeIcon: Icon(Icons.keyboard_arrow_down),
                  openIcon: Icon(Icons.keyboard_arrow_up),
                  errorWidget: Text(
                    'error',
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                  errorBuilder:
                      (context, error) => Tooltip(
                        message: error.toString(),
                        child: Icon(
                          Icons.error_outline,
                          color: Theme.of(context).colorScheme.error,
                          size: 16,
                        ),
                      ),
                  loadingWidget: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.primary,
                    strokeWidth: 2,
                  ),
                  backgroundColor: Colors.transparent,
                ),
              ),
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
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(10.0),
        constraints: BoxConstraints(maxWidth: size.width * 0.9, maxHeight: size.height * 0.9),
        child: Row(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildCodeCard(
              title: 'JSON',
              content: item.json,
              onCopy: () => _copyToClipboard(item.json),
            ),
            _buildCodeCard(
              title: 'Dart',
              content: item.dartCode,
              onCopy: () => _copyToClipboard(item.dartCode),
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
  }) {
    return Expanded(
      child: Card(
        elevation: 0,
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 标题栏
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  IconButton(
                    icon: const Icon(Icons.copy),
                    onPressed: () {
                      onCopy();
                      MessageUtil.showSuccess(title: '操作提示', content: '已成功复制到剪切板');
                    },
                  ),
                ],
              ),
              // 代码内容区域
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: HighlightText(codeText: content, highlighter: controller.highlighter),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
  }
}
