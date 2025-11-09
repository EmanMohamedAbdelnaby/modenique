import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nti_final_project_new/core/utils/app_style/color_app.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: const Color.fromARGB(255, 251, 251, 251),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color.fromARGB(255, 251, 251, 251),
    foregroundColor: Colors.black,
    elevation: 0,
  ),
  textTheme: TextTheme(
    bodyLarge: GoogleFonts.playfairDisplay(
      color: AppColors.blackColor,
      fontSize: 25,
      fontWeight: FontWeight.bold,
    ),
    bodyMedium: GoogleFonts.inter(
      color: AppColors.blackColor,
      fontSize: 15,
    ), // أصغر شوية
    bodySmall: GoogleFonts.inter(color: Colors.black54, fontSize: 12), // أصغر
  ),
  iconTheme: IconThemeData(color: AppColors.blackColor, size: 20), // أصغر
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primaryColor,
      foregroundColor: Colors.white,
      textStyle: const TextStyle(fontWeight: FontWeight.w500),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  ),
  primaryIconTheme: IconThemeData(color: AppColors.blackColor),
  inputDecorationTheme: InputDecorationTheme(iconColor: AppColors.primaryColor),
  cardTheme: CardThemeData(
    elevation: 2,
    color: const Color.fromARGB(255, 253, 249, 249),
    margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),

  listTileTheme: ListTileThemeData(
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    horizontalTitleGap: 8,
    minVerticalPadding: 4,
  ),
);
