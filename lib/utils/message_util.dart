import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

sealed class MessageUtil {
  static void showInfo({String title = '', String content = ''}) {
    show(title: title, content: content, type: ToastificationType.info);
  }

  static void showWarning({String title = '', String content = ''}) {
    show(title: title, content: content, type: ToastificationType.warning);
  }

  static void showError({String title = '', String content = ''}) {
    show(title: title, content: content, type: ToastificationType.error);
  }

  static void showSuccess({String title = '', String content = ''}) {
    show(title: title, content: content, type: ToastificationType.success);
  }

  static void show({
    String title = '',
    String content = '',
    ToastificationType type = ToastificationType.info,
  }) {
    toastification.show(
      title: Text(title),
      description: Text(content),
      type: type,
      autoCloseDuration: Duration(seconds: 2),
      style: ToastificationStyle.flatColored,
    );
  }
}
