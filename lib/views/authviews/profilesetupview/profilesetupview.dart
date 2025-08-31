// import 'package:chattingapp/controller/profilecontroller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'dart:io';
//
//
// /// 1. Profile Setup Screen
// class ProfileSetupView extends StatelessWidget {
//   final ProfileController controller = Get.put(ProfileController());
//   final TextEditingController nameCtrl = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Setup Profile")),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             Obx(() => GestureDetector(
//               onTap: () => controller.pickImage(),
//               child: CircleAvatar(
//                 radius: 50,
//                 backgroundImage: controller.profileImage.value != null
//                     ? FileImage(controller.profileImage.value!)
//                     : (controller.profileImageUrl.value.isNotEmpty
//                     ? NetworkImage(controller.profileImageUrl.value)
//                     : AssetImage("assets/user.png")) as ImageProvider,
//               ),
//             )),
//             SizedBox(height: 20),
//             TextField(
//               controller: nameCtrl,
//               decoration: InputDecoration(labelText: "Your Name"),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () => controller.saveProfile(nameCtrl.text),
//               child: Text("Save & Continue"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'dart:io';
import 'package:chattingapp/constants/appcolors/appcolors.dart';
import 'package:chattingapp/controller/profilecontroller.dart';
import 'package:chattingapp/widgets/textwidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileSetupView extends StatelessWidget {
  ProfileSetupView({super.key});

  final ProfileController controller = Get.put(ProfileController());
  final TextEditingController nameController = TextEditingController();

  // Ab UI seedha controller.pickImage() use karegi
  Future<void> _pickImage() async {
    await controller.pickImage();
  }

  void _onArrowTap() {
    if (nameController.text.trim().isNotEmpty ||
        controller.profileImage.value != null) {
      controller.saveProfile(nameController.text.trim());
    } else {
      Get.defaultDialog(
        title: "No Profile Data",
        middleText: "Do you want to continue without adding name or photo?",
        textCancel: "No",
        textConfirm: "Yes",
        confirmTextColor: AppColors.whiteColor,
        onConfirm: () {
          Get.back();
          Get.offAllNamed("/HomeView");
        },
        onCancel: () {
          Get.back();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title
              TextWidget.h1("Set up your profile"),
              const SizedBox(height: 8),
              TextWidget.body(
                  "Add a profile photo and your name so your friends know it's you."),
              const SizedBox(height: 40),

              // Profile Image Picker
              Center(
                child: Obx(() {
                  return GestureDetector(
                    onTap: _pickImage,
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: AppColors.secondary.withOpacity(0.2),
                          backgroundImage: controller.profileImage.value != null
                              ? FileImage(controller.profileImage.value as File)
                              : (controller.profileImageUrl.value.isNotEmpty
                              ? NetworkImage(controller.profileImageUrl.value)
                              : null),
                          child: controller.profileImage.value == null &&
                              controller.profileImageUrl.value.isEmpty
                              ? Icon(Icons.camera_alt,
                              color: AppColors.whiteColor, size: 40)
                              : null,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primaryColor,
                              border:
                              Border.all(color: AppColors.whiteColor, width: 2)),
                          padding: const EdgeInsets.all(6),
                          child: Icon(Icons.camera_alt,
                              color: AppColors.whiteColor, size: 20),
                        ),
                      ],
                    ),
                  );
                }),
              ),
              const SizedBox(height: 30),

              // Name input
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: "Enter your name",
                  hintStyle: TextStyle(color: AppColors.textSecondary),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.greyColor)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.primaryColor)),
                ),
              ),
              const Spacer(),

              // Bottom Row: Skip & Continue Arrow
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Skip Button
                  TextButton(
                    onPressed: () => Get.offAllNamed("/HomeView"),
                    child: Text(
                      "Skip",
                      style: TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w600),
                    ),
                  ),

                  // Continue Arrow
                  GestureDetector(
                    onTap: _onArrowTap,
                    child: CircleAvatar(
                      radius: 28,
                      backgroundColor: AppColors.primaryColor,
                      child: Icon(Icons.arrow_forward, color: AppColors.whiteColor),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
