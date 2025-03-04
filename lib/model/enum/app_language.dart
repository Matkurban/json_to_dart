import 'dart:ui';

enum AppLanguage {
  chineseSimplified('zh', '中文'),
  english('en', 'English');

  final String code;
  final String displayName;

  const AppLanguage(this.code, this.displayName);

  static AppLanguage fromCode(String code) {
    return values.firstWhere(
      (lang) => lang.code == code,
      orElse: () => AppLanguage.english, // 默认回退到英语
    );
  }

  Locale get locale => Locale(code);
}
