import 'package:flutter/material.dart';
import 'package:nti_final_project_new/core/utils/app_style/color_app.dart';

import '../../data/models/coupon_model.dart';

class CouponCard extends StatelessWidget {
  final CouponModel coupon;

  const CouponCard({super.key, required this.coupon});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6), // أقل من 8
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // أصغر شوية
      ),
      child: Padding(
        padding: const EdgeInsets.all(6.0), // أقل من 8
        child: ListTile(
          leading: Icon(
            Icons.card_giftcard,
            color: AppColors.primaryColor,
            size: 24,
          ), // أقل من default
          title: Text(
            coupon.couponCode,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.w500, // أخف شوية
              fontSize: 16, // أصغر من default
            ),
          ),
          subtitle: Text(
            "${coupon.couponType} - ${coupon.discountValue}% off",
            style: Theme.of(
              context,
            ).textTheme.bodySmall!.copyWith(fontSize: 13), // أصغر
          ),
          trailing: Text(
            "Exp: ${coupon.expiresAt.split('T').first}",
            style: Theme.of(
              context,
            ).textTheme.bodySmall!.copyWith(fontSize: 12), // أصغر
          ),
        ),
      ),
    );
  }
}
