import 'package:flutter/material.dart';
import 'package:json_to_dart/model/domain/dart/history_item.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

sealed class PreviewDialog {
  static void showPreviewDialog(HistoryItem item) {
    showDialog(
      context: Get.context!,
      builder: (context) => _PreviewDialogContent(item: item),
    );
  }
}

class _PreviewDialogContent extends StatelessWidget {
  final HistoryItem item;

  const _PreviewDialogContent({required this.item});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: Get.width * 0.7,
          maxHeight: Get.height * 0.8,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            spacing: 10,
            mainAxisSize: MainAxisSize.min,
            children: [
              // 主要内容区域
              Expanded(
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
              // 底部关闭按钮
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(onPressed: Get.back, child: const Text('关闭')),
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
  }) {
    return Expanded(
      child: Card(
        elevation: 0,
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    icon: const Icon(Icons.copy, size: 20),
                    onPressed: () {
                      onCopy();
                      ScaffoldMessenger.of(Get.context!).showSnackBar(
                        SnackBar(
                          content: Text('$title 已复制到剪贴板'),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // 代码内容区域
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: SelectableText(content),
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
