import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../core/utils/app_style/color_app.dart';

class CustomPinCodeField extends StatelessWidget {
  final void Function(String)? onCompleted;
  const CustomPinCodeField({super.key, this.onCompleted});

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      appContext: context,
      length: 6,
      keyboardType: TextInputType.number,
      obscureText: false,
      animationType: AnimationType.fade,
      pinTheme: PinTheme(
        fieldWidth: 45,
        fieldHeight: 55,
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(10),
        activeColor: AppColors.greyColor.withOpacity(0.5),
        inactiveColor: AppColors.greyColor.withOpacity(0.5),
        activeFillColor: Colors.white,
        selectedColor: AppColors.primaryColor,
        inactiveFillColor: AppColors.whiteColor,
        selectedFillColor: AppColors.whiteColor,
      ),
      textStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.primaryColor,
      ),
      onChanged: (value) => print(value),
      onCompleted: onCompleted,
    );
  }
}
