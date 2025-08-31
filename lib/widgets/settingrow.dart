import 'package:flutter/material.dart';

class SettingRow extends StatelessWidget {
  final Widget leading;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;
  const SettingRow({super.key, required this.leading, required this.title, this.trailing, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading,
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: trailing,
      onTap: onTap,
    );
  }
}