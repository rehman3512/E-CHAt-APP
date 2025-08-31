import 'package:flutter/material.dart';

class MoreItemWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? titleColor;
  final Color? iconColor;

  const MoreItemWidget({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.titleColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      leading: Icon(icon, color: iconColor ?? Colors.blueAccent, size: 26),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          // color: titleColor ?? Colors.black87, // thoda dark
          color: titleColor ??
              (Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black87),

        ),
      ),
      subtitle: subtitle != null
          ? Text(
        subtitle!,
        style: TextStyle(
          fontSize: 13,
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey.shade400
              : Colors.grey.shade600,
        ),
      )
          : null,
      trailing: trailing,
      onTap: onTap,
    );
  }
}
