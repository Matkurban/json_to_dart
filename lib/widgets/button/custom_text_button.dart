import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton({super.key, required this.text, this.onPress});

  final String text;
  final VoidCallback? onPress;

  @override
  Widget build(BuildContext context) {
    var themeData = Theme.of(context);
    return ElevatedButton(
      onPressed: onPress,
      child: Text(text, style: themeData.textTheme.titleMedium),
    );
  }
}
