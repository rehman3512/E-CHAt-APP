import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'loadingcontroller.dart';


class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  Widget _chatBubble(Color? color, {double offsetX = 0}) {
    return Transform.translate(
      offset: Offset(offsetX, 0),
      child: Container(
        width: 80,
        height: 60,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Align(
          alignment: Alignment.bottomRight,
          child: ClipPath(
            clipper: TriangleClipper(),
            child: Container(
              width: 20,
              height: 20,
              color: color,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoadingController());

    return Scaffold(
      backgroundColor: Colors.lightBlue.shade50,
      body: Center(
        child: AnimatedBuilder(
          animation: controller.animationController,
          builder: (context, child) {
            return Opacity(
              opacity: controller.opacityAnim.value,
              child: Transform.scale(
                scale: controller.scaleAnim.value,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    _chatBubble(controller.bubble2Color.value, offsetX: 20),
                    _chatBubble(controller.bubble1Color.value, offsetX: -20),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width, 0);
    path.lineTo(size.width / 2, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
