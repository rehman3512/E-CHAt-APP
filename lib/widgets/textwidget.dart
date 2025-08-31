import 'package:chattingapp/constants/appcolors/appcolors.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class TextWidget extends StatelessWidget {
  final String text;
  final TextStyle style;
  const TextWidget(this.text, {super.key, required this.style});
  factory TextWidget.h1(String t) => TextWidget(t,
      style: GoogleFonts.poppins(
          fontSize: 26,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary));
  factory TextWidget.h2(String t) => TextWidget(t,
      style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary));
  factory TextWidget.body(String t) => TextWidget(t,
      style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textSecondary));
  @override
  Widget build(BuildContext context) => Text(text, style: style);
}
