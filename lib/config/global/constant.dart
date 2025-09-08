import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:json_to_dart/l10n/app_localizations.dart';
import 'package:json_to_dart/utils/message_util.dart';
import 'package:json_to_dart/widgets/dialog/preview_dialog.dart';

const String dartHistoryKey = "dartHistory";
const String javaHistoryKey = "javaHistory";

// 定义时间格式化方法
String formatTimeHHmm(DateTime time) {
  // 获取小时并确保两位数格式
  final hour = time.hour.toString().padLeft(2, '0');
  // 获取分钟并确保两位数格式
  final minute = time.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}

AppLocalizations get l10n => AppLocalizations.of(Get.context!)!;

Future<void> copyToClipboard(String text) async {
  if (text.isEmpty) {
    MessageUtil.showWarning(title: l10n.operationPrompt, content: '复制内容为空');
    return;
  }
  await Clipboard.setData(ClipboardData(text: text));
  MessageUtil.showSuccess(
    title: l10n.operationPrompt,
    content: l10n.codeCopied,
  );
}

///预览Json
void previewJson(BuildContext context, Map<String,dynamic> json) {
  if (json.isEmpty) {
    MessageUtil.showWarning(
      title: l10n.operationPrompt,
      content: l10n.enterJsonPrompt,
    );
    return;
  }
  PreviewDialog.showPreviewJsonDialog(context, json);
}

void previewCode(BuildContext context, String code) {
  if (code.trim().isEmpty) {
    MessageUtil.showWarning(title: l10n.operationPrompt, content: '请生成类后预览');
    return;
  }
  PreviewDialog.showPreviewDartDialog(context, code);
}

const reservedWords = {
  'abstract',
  'as',
  'assert',
  'async',
  'await',
  'break',
  'case',
  'catch',
  'class',
  'const',
  'continue',
  'covariant',
  'default',
  'deferred',
  'do',
  'dynamic',
  'else',
  'enum',
  'export',
  'extends',
  'extension',
  'external',
  'factory',
  'false',
  'final',
  'finally',
  'for',
  'function',
  'get',
  'hide',
  'if',
  'implements',
  'import',
  'in',
  'interface',
  'is',
  'late',
  'library',
  'mixin',
  'new',
  'null',
  'on',
  'operator',
  'part',
  'required',
  'rethrow',
  'return',
  'set',
  'show',
  'static',
  'super',
  'switch',
  'sync',
  'this',
  'throw',
  'true',
  'try',
  'typedef',
  'var',
  'void',
  'while',
  'with',
  'yield',
};
