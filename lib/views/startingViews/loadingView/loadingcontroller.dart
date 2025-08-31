import 'package:chattingapp/routes/approutes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadingController extends GetxController with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<Color?> bubble1Color;
  late Animation<Color?> bubble2Color;
  late Animation<double> scaleAnim;
  late Animation<double> opacityAnim;

  @override
  void onInit() {
    super.onInit();

    animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    bubble1Color = ColorTween(
      begin: Colors.lightBlue.shade100,
      end: Colors.blueAccent,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    ));

    bubble2Color = ColorTween(
      begin: Colors.blue.shade200,
      end: Colors.indigo,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    ));

    scaleAnim = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
    );

    opacityAnim = Tween<double>(begin: 0.2, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
    );

    // Start animation
    animationController.forward();

    // Navigate to Splash screen when animation ends
    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Get.offAndToNamed(AppRoutes.SplashScreen);
      }
    });
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}
