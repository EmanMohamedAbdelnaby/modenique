import 'package:flutter/material.dart';
import 'package:nti_final_project_new/core/utils/app_style/color_app.dart';

class OtherLoginMethods extends StatelessWidget {
  const OtherLoginMethods({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Or continue with", style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.primaryColor),
              ),
              child: Icon(
                Icons.search,
                size: 21,
                color: AppColors.primaryColor,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.primaryColor),
              ),
              child: Icon(
                Icons.facebook_rounded,
                size: 21,
                color: AppColors.primaryColor,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.primaryColor),
              ),
              child: Icon(
                Icons.phone_iphone,
                size: 21,
                color: AppColors.primaryColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
