import 'package:flutter/material.dart';
import 'package:nti_final_project_new/core/utils/app_style/color_app.dart';

import '../../data/models/product_model.dart';

class CustomCardItem extends StatelessWidget {
  final ProductModels item;
  final void Function()? onTap;
  final void Function()? onTapFav;
  final void Function()? onPressedDelet;
  final void Function()? onPressedAddtoCart;
  final bool isFavourite;

  const CustomCardItem({
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
        elevation: 1.5,
        shadowColor: AppColors.blackColor.withOpacity(0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Container(
          width: 170, // أصغر
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(18)),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(18),
                      topRight: Radius.circular(18),
                    ),
                    child: Image.network(
                      (item.coverPictureUrl != null &&
                              item.coverPictureUrl!.isNotEmpty)
                          ? item.coverPictureUrl!
                          : 'https://via.placeholder.com/150',
                      height: 110, // أصغر
                      width: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0), // أصغر
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item.name!,
                          maxLines: 1,
                          style: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(
                                fontSize: 16, // أصغر
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "${item.price!} \$",
                          style: TextStyle(
                            fontSize: 14, // أصغر
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "stock: ${item.stock!.toInt()}",
                          style: Theme.of(context).textTheme.bodySmall!
                              .copyWith(
                                fontSize: 14, // أصغر
                              ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: onPressedDelet,
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red.withOpacity(0.8),
                                size: 20, // أصغر
                              ),
                            ),
                            CircleAvatar(
                              backgroundColor: AppColors.primaryColor,
                              radius: 15, // أصغر
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                onPressed: onPressedAddtoCart,
                                icon: Icon(
                                  Icons.add_shopping_cart_outlined,
                                  color: AppColors.whiteColor,
                                  size: 18, // أصغر
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
                top: 6,
                left: 6,
                child: InkWell(
                  onTap: onTapFav,
                  child: CircleAvatar(
                    radius: 11, // أصغر
                    backgroundColor: const Color.fromARGB(255, 248, 244, 244),
                    child: Icon(
                      isFavourite ? Icons.favorite : Icons.favorite_outline,
                      color: isFavourite ? Colors.red : Colors.black,
                      size: 15, // أصغر
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
