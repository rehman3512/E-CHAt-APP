import 'package:chattingapp/constants/appcolors/appcolors.dart';
import 'package:chattingapp/controller/authcontroller.dart';
import 'package:chattingapp/widgets/textwidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpView extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();

  OtpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Column(
        children: [
          // 🔹 TOP AREA
          Expanded(
            flex: 2,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/splashLogo.png", height: 100),
                  const SizedBox(height: 10),
                  TextWidget.h1("Verify OTP"),
                  const SizedBox(height: 5),
                  Obx(() => TextWidget.body(
                      "Code sent to ${authController.phoneNumber.value}")),
                ],
              ),
            ),
          ),

          // 🔹 OTP INPUT AREA
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),

                  // OTP FIELD
                  PinCodeTextField(
                    appContext: context,
                    length: 6,
                    keyboardType: TextInputType.number,
                    onChanged: (val) => authController.otpCode.value = val,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(10),
                      fieldHeight: 50,
                      fieldWidth: 40,
                      activeColor: AppColors.primary,
                      selectedColor: AppColors.primary,
                      inactiveColor: Colors.grey.shade300,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // VERIFY BUTTON
                  GestureDetector(
                    onTap: () {
                      if (authController.otpCode.value.length == 6) {
                        authController.verifyOtp();
                      } else {
                        Get.snackbar("Error", "Please enter 6 digit code");
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: TextWidget.h2("Verify"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
