import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:json_to_dart/config/global/constant.dart';

sealed class ConfirmDialog {
  ///确认提示弹框
  static void showConfirmDialog({String title = '', String content = '', VoidCallback? onConfirm}) {
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
              child: Text(l10n.cancel, style: TextStyle(color: Theme.of(context).colorScheme.error)),
            ),
            TextButton(
              onPressed: () {
                Get.back();
                if (onConfirm != null) {
                  onConfirm();
                }
              },
              child: Text(l10n.confirm),
            ),
          ],
        );
      },
    );
  }
}
