// import 'package:chattingapp/controller/themecontroller.dart';
// import 'package:chattingapp/routes/approutes.dart';
// import 'package:chattingapp/views/authviews/loginview/loginview.dart';
// import 'package:chattingapp/views/homeviews/chatlistview/chatlistview.dart';
// import 'package:chattingapp/constants/appcolors/appcolors.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/foundation.dart'; // kIsWeb ke liye
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   // ✅ Firebase initialize for Web & Mobile
//   if (kIsWeb) {
//     await Firebase.initializeApp(
//       options: const FirebaseOptions(
//         apiKey: "YOUR_API_KEY",
//         authDomain: "YOUR_PROJECT_ID.firebaseapp.com",
//         projectId: "YOUR_PROJECT_ID",
//         storageBucket: "YOUR_PROJECT_ID.appspot.com",
//         messagingSenderId: "YOUR_SENDER_ID",
//         appId: "YOUR_APP_ID",
//         measurementId: "YOUR_MEASUREMENT_ID",
//       ),
//     );
//   } else {
//     await Firebase.initializeApp();
//   }
//
//   // ✅ Dev mode me reCAPTCHA disable for testing (Remove in production!)
//   if (!kReleaseMode) {
//     await FirebaseAuth.instance.setSettings(appVerificationDisabledForTesting: true);
//   }
//
//   // Theme controller
//   final themeCtrl = Get.put(ThemeController(), permanent: true);
//
//   runApp(MyApp(themeCtrl: themeCtrl));
// }
//
// class MyApp extends StatelessWidget {
//   final ThemeController themeCtrl;
//   const MyApp({super.key, required this.themeCtrl});
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       return GetMaterialApp(
//         debugShowCheckedModeBanner: false,
//         title: 'E-Chat',
//         theme: AppColors.lightTheme,
//         darkTheme: AppColors.darkTheme,
//         themeMode: themeCtrl.isDark.value ? ThemeMode.dark : ThemeMode.light,
//
//         // ✅ Only use initialRoute + getPages (no "home:")
//         initialRoute: AppRoutes.Home,
//         getPages: AppRoutes.routes,
//       );
//     });
//   }
// }
//
// class AuthCheckView extends StatelessWidget {
//   const AuthCheckView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<User?>(
//       stream: FirebaseAuth.instance.authStateChanges(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Scaffold(
//             body: Center(child: CircularProgressIndicator()),
//           );
//         }
//         if (snapshot.hasData) {
//           return const ChatListScreen();
//         } else {
//           return LoginView();
//         }
//       },
//     );
//   }
// }


// import 'package:chattingapp/routes/approutes.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'constants/appcolors/appcolors.dart';
// import 'controller/authcontroller.dart';
// import 'controller/chatlistcontroller.dart';
// import 'controller/homecontroller.dart';
// import 'firebase_options.dart';
//
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   // 🔹 Init Firebase
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//
//   // 🔹 Init Local Storage
//   await GetStorage.init();
//
//   // 🔹 Inject Controllers
//   Get.put(AuthController(), permanent: true);
//   Get.put(HomeController(), permanent: true);
//   Get.put(ChatListController());
//
//   WidgetsFlutterBinding.ensureInitialized();
//
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final HomeController homeController = Get.find<HomeController>();
//
//     return Obx(() => GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: "EChat App",
//       theme: AppColors.lightTheme,
//       darkTheme: AppColors.darkTheme,
//       themeMode: homeController.isDarkMode.value
//           ? ThemeMode.dark
//           : ThemeMode.light,
//       initialRoute: AppRoutes.Login,
//       getPages: AppRoutes.routes,
//     ));
//   }
// }



import 'package:chattingapp/routes/approutes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'constants/appcolors/appcolors.dart';
import 'controller/authcontroller.dart';
import 'controller/chatlistcontroller.dart';
import 'controller/homecontroller.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔹 Init Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 🔹 Init Local Storage
  await GetStorage.init();

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
      initialRoute: AppRoutes.Login,
      getPages: AppRoutes.routes,
    );
  }
}