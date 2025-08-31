import 'package:chattingapp/controller/homecontroller.dart';
import 'package:chattingapp/controller/themecontroller.dart';
import 'package:chattingapp/widgets/customtoggle.dart';
import 'package:chattingapp/widgets/moreitemwidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class MoreView extends StatelessWidget {
  const MoreView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    final theme = Get.put(ThemeController(), permanent: true);

    return Scaffold(
      body: SafeArea(
        child: Obx(() => ListView(
          children: [
            MoreItemWidget(
              icon: Icons.language,
              title: "Language",
              trailing: DropdownButton<String>(
                value: controller.selectedLanguage.value,
                underline: const SizedBox.shrink(),
                items: const [
                  DropdownMenuItem(value: "en", child: Text("English")),
                  DropdownMenuItem(value: "ur", child: Text("Urdu")),
                ],
                onChanged: (v) {
                  if (v != null) controller.changeLanguage(v);
                },
              ),
            ),
            MoreItemWidget(
              icon: Icons.dark_mode_outlined,
              title: "Dark Mode",
              trailing: CustomToggle(
                value: theme.isDark.value,
                onChanged: (_) => theme.toggle(),
              ),
            ),
            MoreItemWidget(
              icon: Icons.volume_off_outlined,
              title: "Mute Notification",
              trailing: CustomToggle(
                value: controller.isMuted.value,
                onChanged: (val) => controller.toggleMute(),
              ),
            ),
            MoreItemWidget(
              icon: Icons.notifications_active_outlined,
              title: "Custom Notification",
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              onTap: () {},
            ),
            const Divider(),
            MoreItemWidget(
              icon: Icons.person_add_alt,
              title: "Invite Friends",
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              onTap: () {},
            ),
            MoreItemWidget(
              icon: Icons.groups_2_outlined,
              title: "Joined Groups",
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              onTap: () {},
            ),
            MoreItemWidget(
              icon: Icons.history_toggle_off,
              title: "Hide Chat History",
              trailing: CustomToggle(
                value: controller.isLockEnabled.value,
                onChanged: (val) => controller.toggleLock(val),
              ),
            ),
            MoreItemWidget(
              icon: Icons.shield_outlined,
              title: "Security",
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              onTap: () => Get.toNamed("/SecurityScreen"),
            ),
            MoreItemWidget(
              icon: Icons.library_books_outlined,
              title: "Term of Service",
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              onTap: () {},
            ),
            MoreItemWidget(
              icon: Icons.info_outline,
              title: "About App",
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              onTap: () {},
            ),
            MoreItemWidget(
              icon: Icons.help_outline,
              title: "Help Center",
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              onTap: () {},
            ),
            MoreItemWidget(
              icon: Icons.logout,
              title: "Logout",
              titleColor: Colors.red,
              iconColor: Colors.red,
              //onTap: () => controller.logout?.call(),
            ),
          ],
        )),
      ),
    );
  }
}
