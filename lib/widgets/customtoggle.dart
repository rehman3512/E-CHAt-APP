import 'package:flutter/material.dart';
import 'package:chattingapp/constants/appcolors/appcolors.dart';

class CustomToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomToggle({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 45,
        height: 24,
        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
        decoration: BoxDecoration(
          color: value ? AppColors.primary : AppColors.greyColor.withOpacity(0.4),
          borderRadius: BorderRadius.circular(20),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 250),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
