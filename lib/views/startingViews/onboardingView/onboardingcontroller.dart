import 'package:chattingapp/constants/appassets/appAssets.dart';
import 'package:chattingapp/routes/approutes.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {
  final pageController = PageController();
  var currentPage = 0.obs;

  final List<Map<String, String>> pages = [
    {
      "image": AppAssets.onboarding1Image,
      "title": "Group Chatting",
      "description": "Connect with multiple members in group chats."
    },
    {
      "image": AppAssets.onboarding2Image,
      "title": "Video And Voice Calls",
      "description": "Instantly connect via video and voice calls."
    },
    {
      "image": AppAssets.onboarding3Image,
      "title": "Message Encryption",
      "description": "Ensure privacy with encrypted messages."
    },
    {
      "image": AppAssets.onboarding4Image,
      "title": "Cross-Platform Compatibility",
      "description": "Access chats on any device seamlessly."
    },
  ];

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  void nextPage() {
    if (currentPage.value < pages.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      finish();
    }
  }

  void skip() {
    finish();
  }

  void finish() {
    Get.offAllNamed(AppRoutes.Login);
  }
}
