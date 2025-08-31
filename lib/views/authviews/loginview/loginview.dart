import 'package:chattingapp/constants/appAssets/appassets.dart';
import 'package:chattingapp/constants/appcolors/appcolors.dart';
import 'package:chattingapp/controller/authcontroller.dart';
import 'package:chattingapp/widgets/custombutton.dart';
import 'package:chattingapp/widgets/textwidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginView extends StatelessWidget {
  final AuthController controller = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Column(
        children: [
          // TOP LOGO & TEXT
          Expanded(
            flex: 1,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(AppAssets.splashEchatLogoImage, height: 80, width: 80),
                  const SizedBox(height: 12),
                  TextWidget.h1("Welcome Back"),
                  TextWidget.body("Login to continue"),
                ],
              ),
            ),
          ),

          // BOTTOM HALF CONTAINER
          Expanded(
            flex: 1,
            child: Container(
              width: size.width,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 6),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget.h2("Enter your mobile number"),
                  const SizedBox(height: 6),
                  TextWidget.body("You will get an SMS verification code."),

                  const SizedBox(height: 15),

                  // Only Pakistan Phone Input
                  Obx(() => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        decoration: InputDecoration(
                          prefixText: "+92 ",
                          counterText: "", // hide default counter
                          hintText: "",
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey.shade400, width: 1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onChanged: (val) =>
                            controller.setPhone("+92${val.trim()}"),
                      ),
                      const SizedBox(height: 4),
                      TextWidget.body(
                        "${controller.phoneNumber.value.length > 3 ? controller.phoneNumber.value.substring(3).length : 0}/10 digits entered",
                      ),
                    ],
                  )),

                  Row(
                    children: [
                      Obx(() => Checkbox(
                        value: controller.rememberMe.value,
                        activeColor: AppColors.primary,
                        onChanged: (val) =>
                            controller.toggleRemember(val ?? false),
                      )),
                      TextWidget.body("Remember me"),
                    ],
                  ),

                  const Spacer(),

                  Align(
                    alignment: Alignment.centerRight,
                    child: CustomButton(
                      onTap: () => controller.login(),
                      icon: Icons.arrow_forward,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
