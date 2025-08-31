import 'package:flutter/material.dart';
import 'package:chattingapp/constants/appcolors/appcolors.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  const CustomButton({super.key, required this.onTap, required this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 24,
        backgroundColor: AppColors.primary,
        child: Icon(icon, color: AppColors.whiteColor),
      ),
    );
  }
}
