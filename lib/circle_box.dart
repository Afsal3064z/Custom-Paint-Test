import 'package:flutter/material.dart';

class CircleBox extends StatelessWidget {
  final bool isCurrent;

  const CircleBox({required this.isCurrent, super.key, required int index});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: isCurrent ? Colors.blue : Colors.grey,
        shape: BoxShape.circle,
      ),
      width: 100,
      height: 100,
      child: Center(
        child: Text(
          isCurrent ? "Current" : "Not Current",
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
