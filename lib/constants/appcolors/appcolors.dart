// import 'package:flutter/material.dart';
//
// class AppColors {
//   // Legacy palette kept (do not change values)
//   static const primary = Color(0xFF0EA5A9);
//   static const bg = Color(0xFFF8FAFC);
//   static const surface = Color(0xFFFFFFFF);
//   static const textPrimary = Color(0xFF07122B);
//   static const textSecondary = Color(0xFF667085);
//
//   static const Color primarycolor = Color(0xFF2196F3);
//   static const Color secondary = Color(0xFF64B5F6);
//   static const Color background = Color(0xFFE3F2FD);
//   static const Color textPrimarycolor = Colors.black87;
//   static const Color textSecondarycolor = Colors.black54;
//
//   // Older WhatsApp-like palette kept for existing UI
//   static const Color primaryColor = Color(0xff075E54);
//   static const Color accentColor = Color(0xff25D366);
//   static const Color backgroundColor = Color(0xffECE5DD);
//   static const Color whiteColor = Color(0xffFFFFFF);
//   static const Color blackColor = Color(0xff000000);
//   static const Color greyColor = Color(0xff7A7A7A);
//   static const Color redColor = Color(0xffFF3B30);
//
//   // Themes (no visual change for widgets using AppColors)
//   static final ThemeData lightTheme = ThemeData(
//     brightness: Brightness.light,
//     useMaterial3: true,
//     scaffoldBackgroundColor: bg,
//     primaryColor: primary,
//     appBarTheme: const AppBarTheme(
//       backgroundColor: surface,
//       elevation: 0,
//       foregroundColor: textPrimary,
//     ),
//     colorScheme: const ColorScheme.light(
//       primary: primary,
//       surface: surface,
//       background: bg,
//     ),
//     switchTheme: SwitchThemeData(
//       trackColor: MaterialStateProperty.all(primary.withOpacity(0.4)),
//       thumbColor: MaterialStateProperty.all(Colors.white),
//     ),
//   );
//
//   static final ThemeData darkTheme = ThemeData(
//     brightness: Brightness.dark,
//     useMaterial3: true,
//     scaffoldBackgroundColor: const Color(0xFF0B1220),
//     primaryColor: primary,
//     colorScheme: const ColorScheme.dark(
//       primary: primary,
//       surface: Color(0xFF111827),
//       background: Color(0xFF0B1220),
//     ),
//     appBarTheme: const AppBarTheme(
//       backgroundColor: Color(0xFF111827),
//       foregroundColor: Colors.white,
//     ),
//     switchTheme: SwitchThemeData(
//       trackColor: MaterialStateProperty.all(primary.withOpacity(0.5)),
//       thumbColor: MaterialStateProperty.all(Colors.white),
//     ),
//   );
// }


import 'package:flutter/material.dart';

class AppColors {
  // Legacy palette kept (do not change values)
  static const primary = Color(0xFF0EA5A9);
  static const bg = Color(0xFFF8FAFC);
  static const surface = Color(0xFFFFFFFF);
  static const textPrimary = Color(0xFF07122B);
  static const textSecondary = Color(0xFF667085);

  static const Color primarycolor = Color(0xFF2196F3);
  static const Color secondary = Color(0xFF64B5F6);
  static const Color background = Color(0xFFE3F2FD);
  static const Color textPrimarycolor = Colors.black87;
  static const Color textSecondarycolor = Colors.black54;

  // Older WhatsApp-like palette kept for existing UI
  static const Color primaryColor = Color(0xff075E54);
  static const Color accentColor = Color(0xff25D366);
  static const Color backgroundColor = Color(0xffECE5DD);
  static const Color whiteColor = Color(0xffFFFFFF);
  static const Color blackColor = Color(0xff000000);
  static const Color greyColor = Color(0xff7A7A7A);
  static const Color redColor = Color(0xffFF3B30);

  // Themes (no visual change for widgets using AppColors)
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    scaffoldBackgroundColor: bg,
    primaryColor: primary,
    appBarTheme: const AppBarTheme(
      backgroundColor: surface,
      elevation: 0,
      foregroundColor: textPrimary,
    ),
    colorScheme: const ColorScheme.light(
      primary: primary,
      surface: surface,
      // ✅ background removed (deprecated in 3.19+)
    ),
    switchTheme: SwitchThemeData(
      trackColor: WidgetStatePropertyAll(
        primary.withValues(alpha: 0.4), // ✅ withOpacity → withValues
      ),
      thumbColor: const WidgetStatePropertyAll(Colors.white), // ✅ MaterialStateProperty → WidgetStateProperty
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    scaffoldBackgroundColor: const Color(0xFF0B1220),
    primaryColor: primary,
    colorScheme: const ColorScheme.dark(
      primary: primary,
      surface: Color(0xFF111827),
      // ✅ background removed
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF111827),
      foregroundColor: Colors.white,
    ),
    switchTheme: SwitchThemeData(
      trackColor: WidgetStatePropertyAll(
        primary.withValues(alpha: 0.5),
      ),
      thumbColor: const WidgetStatePropertyAll(Colors.white),
    ),
  );
}
