import 'package:flutter/services.dart' show rootBundle;

sealed class FileUtil {
  ///读取本地文件后赋值
  static Future<String> readAsset(String path) {
    return rootBundle.loadString(path);
  }
}
