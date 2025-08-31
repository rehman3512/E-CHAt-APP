import 'package:chattingapp/constants/appassets/appAssets.dart';
import 'package:chattingapp/views/startingViews/splashView/splashcontroller.dart';
import 'package:chattingapp/widgets/appcirclebubble.dart';
import 'package:chattingapp/widgets/textwidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SplashController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /// 🔹 Logo
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Image.asset(AppAssets.splashEchatLogoImage, height: 90),
            ),

            /// 🔹 Middle Circle Bubble
            Expanded(
              child: Center(
                child: AppCircleBubble(
                  children: [
                    TextWidget.h2("Stay Connected"),
                    const SizedBox(height: 8),
                    TextWidget.h2("Stay Chatting"),
                  ],
                ),
              ),
            ),

            /// 🔹 Version Text
            const Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Text(
                "Version 2.1.0",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.blue,   // 👈 direct color yaha use karo
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
