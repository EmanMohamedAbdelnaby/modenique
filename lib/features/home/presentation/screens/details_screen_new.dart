import 'package:flutter/material.dart';
import 'package:nti_final_project_new/features/home/data/models/product_model.dart';
import 'package:provider/provider.dart';

import '/core/utils/app_style/color_app.dart';
import '/core/utils/app_style/text_style_app.dart';
import '../../data/services/cart_service.dart';
import 'cart_screen.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final _favoriteStatus = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)!.settings.arguments as ProductModels;
    Provider.of<CartService>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          product.name!,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 20),
        ),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          color: AppColors.blackColor,
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            color: AppColors.blackColor,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// صورة المنتج
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  product.coverPictureUrl ??
                      'https://via.placeholder.com/300x300',
                  height: 280,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),

            /// اسم المنتج
            Text(
              product.name ?? 'Untitled Product',
              style: AppTextSty.blackBold20.copyWith(fontSize: 22),
            ),
            const SizedBox(height: 8),

            /// السعر
            Text(
              "\$${product.price ?? 0}",
              style: AppTextSty.titleAuthTextStyle.copyWith(
                color: AppColors.primaryColor,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 16),

            /// الوصف
            Text(
              product.description ?? 'No description available.',
              style: AppTextSty.greyRegular14.copyWith(fontSize: 14),
            ),
            const SizedBox(height: 20),

            /// أزرار الإضافة والمفضلة
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      // CartCubit;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${product.name} added to cart',
                            style: AppTextSty.whiteBold16.copyWith(
                              fontSize: 16,
                            ),
                          ),
                          backgroundColor: AppColors.primaryColor,
                        ),
                      );
                    },
                    child: Text(
                      'Add to Cart',
                      style: AppTextSty.whiteBold16.copyWith(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ValueListenableBuilder<bool>(
                  valueListenable: _favoriteStatus,
                  builder: (context, isFav, _) {
                    return GestureDetector(
                      onTap: () => _favoriteStatus.value = !isFav,
                      child: Container(
                        height: 50,
                        width: 55,
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.greyColor.withOpacity(0.3),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.greyColor.withOpacity(0.2),
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav
                              ? AppColors.primaryColor
                              : AppColors.greyColor,
                          size: 28,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
