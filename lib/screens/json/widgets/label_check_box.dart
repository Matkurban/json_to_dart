import 'package:flutter/material.dart';

class LabelCheckBox extends StatelessWidget {
  const LabelCheckBox({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });
  final String label;
  final bool value;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [Checkbox(value: value, onChanged: onChanged), Text(label)],
    );
  }
}
