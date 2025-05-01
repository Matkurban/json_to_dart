import 'package:flutter/material.dart';

class CircleContainer extends StatelessWidget {
  const CircleContainer({super.key, required this.item});

  final int item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey.shade100,
      ),
      alignment: Alignment.center,
      child: Text(
        item.toString(),
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
    );
  }
}
