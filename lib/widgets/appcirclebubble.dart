import 'package:flutter/material.dart';

class AppCircleBubble extends StatelessWidget {
  final List<Widget> children;

  const AppCircleBubble({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 250,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.lightBlue, width: 8),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: children,
        ),
      ),
    );
  }
}
