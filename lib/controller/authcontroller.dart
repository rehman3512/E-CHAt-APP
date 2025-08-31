import 'dart:io';
import 'package:chattingapp/data/services/authservice.dart';
import 'package:chattingapp/routes/approutes.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';


class AuthController extends GetxController {
  final AuthService _auth = AuthService();

  final phoneNumber = ''.obs; // e.g., +92xxxxxxxxxx
  final rememberMe = false.obs;
  final otpCode = ''.obs;
  final verificationId = ''.obs;

  final name = ''.obs;
  final profileImage = Rx<File?>(null);

  void setPhone(String v) => phoneNumber.value = v;
  void toggleRemember(bool v) => rememberMe.value = v;
  void setName(String v) => name.value = v;
  void setProfileImage(File f) => profileImage.value = f;

  // Future<void> login() async {
  //   if (phoneNumber.value.isEmpty) return;
  //   await _auth.sendCode(phoneNumber.value, (id) {
  //     verificationId.value = id;
  //     Get.toNamed(AppRoutes.OTP);
  //   });
  // }

  Future<void> login() async {
    if (phoneNumber.value.isEmpty || phoneNumber.value.length != 13) {
      Get.snackbar("Error", "Enter valid Pakistani number e.g. +923001234567");
      return;
    }

    try {
      // 🔹 Firebase Testing Shortcut (dev only)
      if (phoneNumber.value == "+923001234567") {
        final fakeCred = PhoneAuthProvider.credential(
          verificationId: "test-verification-id",
          smsCode: "123456",
        );
        await FirebaseAuth.instance.signInWithCredential(fakeCred);
        Get.offAllNamed(AppRoutes.ProfileSetup);
        return;
      }

      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber.value,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (cred) async {
          await FirebaseAuth.instance.signInWithCredential(cred);
          Get.offAllNamed(AppRoutes.ProfileSetup);
        },
        verificationFailed: (FirebaseAuthException e) {
          print("🔥 verificationFailed: ${e.code} -> ${e.message}");
          Get.snackbar("Error", e.message ?? "Verification failed");
        },
        codeSent: (verId, _) {
          verificationId.value = verId;
          Get.toNamed(AppRoutes.OTP);
        },
        codeAutoRetrievalTimeout: (verId) {
          verificationId.value = verId;
        },
      );
    } catch (e) {
      print("❌ login() exception: $e");
      Get.snackbar("Error", "Failed to send code: $e");
    }
  }



  Future<void> verifyOtp() async {
    if (otpCode.value.length != 6) return;
    await _auth.verifyCode(verificationId.value, otpCode.value);
    Get.offAllNamed(AppRoutes.ProfileSetup);
  }

  Future<void> saveProfileToFirestore() async {
    await _auth.saveProfile(name: name.value, photo: profileImage.value);
    Get.offAllNamed(AppRoutes.Home);
  }
}
