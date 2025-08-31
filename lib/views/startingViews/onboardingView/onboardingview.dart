import 'package:chattingapp/widgets/onboardingpage.dart';
import 'package:chattingapp/widgets/textwidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'onboardingcontroller.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            /// 🔹 PageView
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                itemCount: controller.pages.length,
                itemBuilder: (context, index) {
                  final page = controller.pages[index];
                  return OnboardingPage(
                    image: page["image"]!,
                    title: page["title"]!,
                    description: page["description"]!,
                  );
                },
              ),
            ),

            /// 🔹 Bottom Navigation
            Obx(() => Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// Skip button
                  GestureDetector(
                    onTap: controller.skip,
                    child: TextWidget.body("Skip"),
                  ),

                  /// Dots indicator
                  Row(
                    children: List.generate(
                      controller.pages.length,
                          (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: controller.currentPage.value == index
                              ? Colors.blue
                              : Colors.grey.shade300,
                        ),
                      ),
                    ),
                  ),

                  /// Next / Done button
                  GestureDetector(
                    onTap: () {
                      if (controller.currentPage.value ==
                          controller.pages.length - 1) {
                        controller.finish(); // 👈 Done
                      } else {
                        controller.nextPage(); // 👈 Next
                      }
                    },
                    child: TextWidget.body(
                      controller.currentPage.value ==
                          controller.pages.length - 1
                          ? "Done"
                          : "Next",
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
