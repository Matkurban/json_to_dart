import 'package:flutter/material.dart';

class LoadError extends StatelessWidget {
  const LoadError({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Icon(Icons.error_outline, color: Theme.of(context).colorScheme.error));
  }
}
