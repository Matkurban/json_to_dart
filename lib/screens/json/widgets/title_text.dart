import 'package:flutter/material.dart';

class TitleText extends StatelessWidget {
  final String text;

  const TitleText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Text(
      text,
      style: themeData.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: themeData.colorScheme.primary,
      ),
    );
  }
}
