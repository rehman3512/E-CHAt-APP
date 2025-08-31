import 'package:chattingapp/routes/approutes.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();

    Future.delayed(const Duration(seconds: 3), () {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // ✅ Already logged in → Home
        Get.offAllNamed(AppRoutes.Home);
      } else {
        // ❌ Not logged in → Onboarding/Login
        Get.offAllNamed(AppRoutes.OnboardingScreen);
      }
    });
  }
}
