import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nti_final_project_new/core/utils/app_style/color_app.dart';

class AppTextSty {
  static TextStyle titleAuthTextStyle = GoogleFonts.playfairDisplay(
    fontSize: 30,
    fontWeight: FontWeight.w800,
    color: AppColors.primaryColor,
  );
  static TextStyle blackBold20 = GoogleFonts.alexandria(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.blackColor,
  );
  static TextStyle whiteBold25 = GoogleFonts.alexandria(
    fontSize: 25,
    fontWeight: FontWeight.bold,
    color: AppColors.textInButtonColor,
  );
  static TextStyle whiteBold16 = GoogleFonts.alexandria(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.textInButtonColor,
  );
  static TextStyle blackRegular14 = GoogleFonts.alexandria(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.blackColor,
  );

  static TextStyle greyRegular14 = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.greyColor,
  );
}
