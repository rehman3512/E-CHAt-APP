import 'package:chattingapp/constants/appAssets/appassets.dart';
import 'package:chattingapp/controller/homecontroller.dart';
import 'package:chattingapp/views/homeViews/moreView/moreview.dart';
import 'package:chattingapp/views/homeviews/chatlistview/chatlistview.dart';
import 'package:chattingapp/views/homeviews/groupchatlistview/groupchatlistview.dart';
import 'package:chattingapp/views/homeviews/profileview/profileview.dart';
import 'package:chattingapp/widgets/appbottomnav.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});
  final c = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Obx(() => c.isSearching.value ? _SearchBar(c) : _HeaderBar(c)),
            Expanded(
              child: Obx(() {
                if (c.rxIndex.value == 0) return ChatListScreen();
                if (c.rxIndex.value == 1) return GroupListScreen();
                if (c.rxIndex.value == 2) return ProfileView();
                return MoreView();
              }),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Obx(() => AppBottomNav(
        index: c.rxIndex.value,
        onTap: (i) => c.rxIndex.value = i,
      )),
    );
  }
}

// ---------- Header ----------
class _HeaderBar extends StatelessWidget {
  final HomeController c;
  const _HeaderBar(this.c);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: 88,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [Colors.blueGrey.shade800, Colors.blueGrey.shade600]
              : [const Color(0xFF1677C3), const Color(0xFF0BA5EC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(18)),
      ),
      child: Row(
        children: [
          Row(
            children: [
              Image.asset(AppAssets.appLogoImage, height: 28, width: 28),
              const SizedBox(width: 8),
              Text(
                "E-Chat",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const Spacer(),
          GestureDetector(
              onTap: c.openSearch,
              child: const Icon(Icons.search, color: Colors.white, size: 26)),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  backgroundColor: theme.cardColor,
                  title: Text("Choose Action",
                      style: theme.textTheme.titleMedium),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.person_add),
                        title: Text("Add Friend", style: theme.textTheme.bodyMedium),
                        onTap: () {
                          Navigator.pop(context);
                          final nameCtrl = TextEditingController();
                          final phoneCtrl = TextEditingController();

                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              backgroundColor: theme.cardColor,
                              title: Text("Add Contact",
                                  style: theme.textTheme.titleMedium),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    controller: nameCtrl,
                                    decoration: const InputDecoration(labelText: "Name"),
                                  ),
                                  TextField(
                                    controller: phoneCtrl,
                                    maxLength: 10, // sirf 10 digits
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      prefixText: "+92 ",
                                      labelText: "Phone (10 digits)",
                                    ),
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("Cancel")),
                                TextButton(
                                  onPressed: () async {
                                    String phone = "+92${phoneCtrl.text.trim()}";
                                    await c.addFriendWithName(
                                        phone, nameCtrl.text.trim());
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Add"),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.group_add),
                        title: Text("Create Group", style: theme.textTheme.bodyMedium),
                        onTap: () {
                          Navigator.pop(context);
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              backgroundColor: theme.cardColor,
                              title: Text("Create Group",
                                  style: theme.textTheme.titleMedium),
                              content: const Text("Group creation UI yahan aayega"),
                              actions: [
                                TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("Close")),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
            child: const Icon(Icons.add_circle_outline,
                color: Colors.white, size: 26),
          )
        ],
      ),
    );
  }
}

// ---------- Search Bar ----------
class _SearchBar extends StatelessWidget {
  final HomeController c;
  const _SearchBar(this.c);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: 88,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [Colors.blueGrey.shade800, Colors.blueGrey.shade600]
              : [const Color(0xFF1677C3), const Color(0xFF0BA5EC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(18)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(22)),
              child: TextField(
                autofocus: true,
                style: theme.textTheme.bodyMedium,
                decoration: InputDecoration(
                  hintText: "Search",
                  border: InputBorder.none,
                  hintStyle: theme.textTheme.bodySmall,
                ),
                onChanged: (v) => c.query.value = v,
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
              onTap: c.closeSearch,
              child: const Icon(Icons.close, color: Colors.white, size: 26)),
        ],
      ),
    );
  }
}
