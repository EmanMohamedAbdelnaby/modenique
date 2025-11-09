import 'package:flutter/material.dart';
import 'package:nti_final_project_new/core/utils/app_style/color_app.dart';

import '../../data/models/product_model.dart';

class CustomCardItemHome extends StatelessWidget {
  final ProductModels item;
  final void Function()? onTap;
  final void Function()? onTapFav;
  final void Function()? onPressedDelet;
  final void Function()? onPressedAddtoCart;
  final bool isFavourite;

  const CustomCardItemHome({
    super.key,
    this.onTap,
    required this.item,
    this.onTapFav,
    this.isFavourite = false,
    this.onPressedDelet,
    this.onPressedAddtoCart,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 2,
        shadowColor: AppColors.blackColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: 160, 
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    child: Image.network(
                      (item.coverPictureUrl != null &&
                              item.coverPictureUrl!.isNotEmpty)
                          ? item.coverPictureUrl!
                          : 'https://via.placeholder.com/150',
                      height: 110, // صغرنا الارتفاع
                      width: 160,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0), // قللنا البادينج
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item.name!,
                          maxLines: 1,
                          style: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(
                                fontSize: 14, // صغرنا حجم الخط
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "${item.price!} \$",
                          style: TextStyle(
                            fontSize: 13, // صغرنا حجم الخط
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "stock: ${item.stock!.toInt()}",
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium!.copyWith(fontSize: 12),
                            ),

                            CircleAvatar(
                              backgroundColor: AppColors.primaryColor,
                              radius: 14,
                              child: IconButton(
                                onPressed: onPressedAddtoCart,
                                icon: Icon(
                                  Icons.add_shopping_cart_outlined,
                                  color: AppColors.whiteColor,
                                  size: 18, // صغرنا الايقونة
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 7, // عدّلنا شوية
                left: 7,
                child: InkWell(
                  onTap: onTapFav,
                  child: CircleAvatar(
                    radius: 11, // صغرنا الراديوس
                    backgroundColor: const Color.fromARGB(255, 248, 244, 244),
                    child: Icon(
                      isFavourite ? Icons.favorite : Icons.favorite_outline,
                      color: isFavourite ? Colors.red : Colors.black,
                      size: 15, // صغرنا الايقونة
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
