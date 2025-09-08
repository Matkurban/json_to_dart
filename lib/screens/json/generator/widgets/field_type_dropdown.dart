import 'package:flutter/material.dart';

class FieldTypeDropdown extends StatefulWidget {
  final String value;
  final ValueChanged<String> onChanged;
  final List<DropdownMenuItem<String>> items;
  const FieldTypeDropdown({
    super.key,
    required this.value,
    required this.onChanged,
    required this.items,
  });

  @override
  State<FieldTypeDropdown> createState() => _FieldTypeDropdownState();
}

class _FieldTypeDropdownState extends State<FieldTypeDropdown> {
  late String _selectedType;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.value;
  }

  @override
  void didUpdateWidget(covariant FieldTypeDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _selectedType = widget.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: _selectedType,
      decoration: const InputDecoration(
        labelText: "类型",
        isDense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      ),
      items: widget.items,
      onChanged: (val) {
        if (val != null && val != _selectedType) {
          setState(() {
            _selectedType = val;
          });
          widget.onChanged(val);
        }
      },
    );
  }
}
