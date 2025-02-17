import 'package:flutter/material.dart';
import 'package:get/get.dart';

sealed class ConfirmDialog {
  ///确认提示弹框
  static void showConfirmDialog({
    String title = '',
    String content = '',
    VoidCallback? onConfirm,
  }) {
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: Get.back,
              child: Text(
                '取消',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
            TextButton(
              onPressed: () {
                Get.back();
                if (onConfirm != null) {
                  onConfirm();
                }
              },
              child: Text('确定'),
            ),
          ],
        );
      },
    );
  }
}

/* Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 20,
                ),
                child: Text(
                  title,
                  style: textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Divider(height: 1),
              Container(
                constraints: BoxConstraints(minHeight: 200),
                child: Text(content, style: textTheme.bodyLarge),
              ),
              Divider(height: 1),
              Row(
                spacing: 10,
                children: [
                  TextButton(onPressed: Get.back, child: Text('取消')),
                  TextButton(
                    onPressed: () {
                      Get.back();
                      if (onConfirm != null) {
                        onConfirm();
                      }
                    },
                    child: Text('确定'),
                  ),
                ],
              ),
            ],
          ),
        ) */
