import 'package:chattingapp/routes/approutes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'constants/appcolors/appcolors.dart';
import 'controller/authcontroller.dart';
import 'controller/chatlistcontroller.dart';
import 'controller/homecontroller.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await GetStorage.init();

  Get.put(AuthController(), permanent: true);
  Get.put(HomeController(), permanent: true);
  Get.put(ChatListController(), permanent: true);

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "EChat App",
      theme: AppColors.lightTheme,
      darkTheme: AppColors.darkTheme,
      themeMode: ThemeMode.system, // Let system decide theme
      initialRoute: AppRoutes.LoadingScreen,
      getPages: AppRoutes.routes,
    );
  }
}