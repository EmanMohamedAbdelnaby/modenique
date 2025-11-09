import 'package:flutter/material.dart';
import 'package:nti_final_project_new/core/utils/app_style/color_app.dart';

class TextFormeFieldStyle extends StatelessWidget {
  final String? hintText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final double? width;
  final bool? isPassword;
  final int? maxLin;
  final TextStyle? hintTextStyle;
  final TextEditingController? controller;
  final String? Function(String?)? validate;

  const TextFormeFieldStyle({
    super.key,
    this.hintText,
    this.suffixIcon,
    this.width,
    this.isPassword,
    this.controller,
    this.validate,
    this.prefixIcon,
    this.maxLin,
    this.hintTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      child: TextFormField(
        maxLines: maxLin ?? 1,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: controller,
        validator: validate,
        obscureText: isPassword ?? false,
        autofocus: false,
        style: Theme.of(context).textTheme.bodyMedium, // الخط متوافق مع Theme
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          hintText: hintText ?? "",
          hintStyle: hintTextStyle ?? Theme.of(context).textTheme.bodySmall,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 204, 205, 208),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.primaryColor, width: 1),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 1),
          ),
          filled: true,
          fillColor: Colors.transparent,
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}
