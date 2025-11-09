import 'package:flutter/material.dart';

class PrimaryButtonWidget extends StatelessWidget {
  final String? bootonText;
  final Color? buttonColor;
  final double? buttonWidth;
  final double? buttonHight;
  final double? borderRaduis;
  final Color? textColor;
  final double? fontsize;
  final void Function()? onpressed;
  const PrimaryButtonWidget(
      {super.key,
      required this.bootonText,
      this.buttonColor,
      this.buttonWidth,
      this.buttonHight,
      this.borderRaduis,
      this.textColor,
      required this.onpressed,
      this.fontsize});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onpressed,
      style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRaduis ?? 100)),
          fixedSize: Size(buttonWidth ?? 250, buttonHight ?? 50)),
      child: Text(
        bootonText ?? "",
        style: TextStyle(
            fontSize: fontsize,
            fontWeight: FontWeight.bold,
            color: textColor ?? Colors.white),
      ),
    );
  }
}
