import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nti_final_project_new/core/utils/app_style/color_app.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Colors.black,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.black,
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  textTheme: TextTheme(
    bodyLarge: GoogleFonts.playfairDisplay(
      color: AppColors.whiteColor,
      fontSize: 25,
      fontWeight: FontWeight.bold,
    ),
    bodyMedium: GoogleFonts.inter(color: Colors.grey[400], fontSize: 14),
  ),
  iconTheme: const IconThemeData(color: Colors.white),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primaryColor,
      foregroundColor: Colors.white,
      textStyle: const TextStyle(fontWeight: FontWeight.bold),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
);
