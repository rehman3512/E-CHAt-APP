import 'package:flutter/material.dart';

class InfoRow extends StatelessWidget {
  final String title;
  final String value;
  const InfoRow({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text("$title: ",
            style: const TextStyle(fontWeight: FontWeight.bold)),
        Expanded(child: Text(value)),
        const Icon(Icons.copy, size: 18, color: Colors.grey),
      ],
    );
  }
}

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color color;
  const PrimaryButton({super.key, required this.text, required this.onTap, this.color = Colors.lightBlue});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: color,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10))),
      onPressed: onTap,
      child: Text(text, style: const TextStyle(color: Colors.white)),
    );
  }
}
