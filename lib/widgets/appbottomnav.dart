import 'package:chattingapp/constants/appcolors/appcolors.dart';
import 'package:flutter/material.dart';

class AppBottomNav extends StatelessWidget {
  final int index;
  final ValueChanged<int> onTap;
  const AppBottomNav({super.key, required this.index, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 66,
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _item(icon: Icons.chat_bubble, label: 'Chats', i: 0),
          _item(icon: Icons.groups_2, label: 'Groups', i: 1),
          _item(icon: Icons.person, label: 'Profile', i: 2),
          _item(icon: Icons.menu, label: 'More', i: 3), // ✅ More tab added
        ],
      ),
    );
  }

  Widget _item({required IconData icon, required String label, required int i}) {
    final active = i == index;
    return GestureDetector(
      onTap: () => onTap(i),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: active ? 16 : 14,
            backgroundColor: active ? AppColors.primary : const Color(0xFFE6F6F7),
            child: Icon(
              icon,
              size: active ? 18 : 16,
              color: active ? AppColors.whiteColor : AppColors.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: active ? AppColors.textPrimary : AppColors.textSecondary,
              fontWeight: active ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
