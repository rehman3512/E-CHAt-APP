import 'package:chattingapp/views/startingViews/onboardingView/onboardingcontroller.dart';
import 'package:chattingapp/widgets/textwidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingPage extends StatelessWidget {
  final String image;
  final String title;
  final String description;

  const OnboardingPage({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController>();

    return Column(
      children: [
        const SizedBox(height: 40),
        Image.asset(image, height: 220),

        const SizedBox(height: 30),
        TextWidget.h1(title),   // 👈 Title ke liye

        const SizedBox(height: 10),
        TextWidget.body(description),   // 👈 Description ke liye

        const Spacer(),

        /// 🔹 Get started button
        GestureDetector(
          onTap: controller.finish, // 👈 Navigate to Home
          child: Container(
            margin: const EdgeInsets.only(bottom: 40),
            width: 200,
            height: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              gradient: const LinearGradient(
                colors: [Colors.lightBlueAccent, Colors.blue],
              ),
            ),
            child: const Center(
              child: Text(
                "Get started",
                style: TextStyle(
                  color: Colors.white,   // 👈 Direct color yaha
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
