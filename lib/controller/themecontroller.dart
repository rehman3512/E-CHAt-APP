import 'package:get/get.dart';
import 'package:chattingapp/constants/appcolors/appcolors.dart';

class ThemeController extends GetxController {
  final isDark = false.obs;

  @override
  void onInit() {
    // Optionally load from storage later
    super.onInit();
  }

  void toggle() {
    isDark.value = !isDark.value;
    Get.changeTheme(isDark.value ? AppColors.darkTheme : AppColors.lightTheme);
  }
}
