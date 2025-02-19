import 'package:flutter/material.dart';

sealed class AppStyle {
  ///默认内边距
  static const EdgeInsets defaultPadding = EdgeInsets.all(10.0);

  ///代码文字样式
  static const TextStyle codeTextStyle = TextStyle(fontSize: 16, height: 1.2);
}
