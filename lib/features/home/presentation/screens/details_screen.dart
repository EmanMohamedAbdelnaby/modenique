import 'package:flutter/material.dart';
import 'package:nti_final_project_new/core/utils/app_constant/routes.dart';
import 'package:nti_final_project_new/features/home/presentation/cubit/cart_cubit.dart';
import 'package:provider/provider.dart';

import '/core/utils/app_style/color_app.dart';
import '/core/utils/app_style/text_style_app.dart';
import '../../data/models/product_model.dart';
import 'cart_screen.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final _favoriteStatus = ValueNotifier<bool>(false);

  final double _averageRating = 4.5;
  final int _totalReviews = 125;
  final List<Map<String, dynamic>> _ratingDistribution = [
    {'stars': 5, 'percentage': 0.65, 'count': 81},
    {'stars': 4, 'percentage': 0.20, 'count': 25},
    {'stars': 3, 'percentage': 0.10, 'count': 13},
    {'stars': 2, 'percentage': 0.03, 'count': 4},
    {'stars': 1, 'percentage': 0.02, 'count': 2},
  ];

  final List<Map<String, dynamic>> _reviews = [
    {
      'author': 'John Doe',
      'rating': 5,
      'date': '2 days ago',
      'comment': 'Excellent product! The quality is outstanding.',
    },
  ];

  void _addReview(String comment, double rating) {
    setState(() {
      _reviews.insert(0, {
        'author': 'You',
        'rating': rating,
        'date': 'Just now',
        'comment': comment,
      });
    });
  }

  @override
  void dispose() {
    _favoriteStatus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)!.settings.arguments as ProductModels;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 70,
        title: Text(
          product.name!,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.shopping_cart_outlined,
              color: AppColors.primaryColor,
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CartScreen()),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if ((product.coverPictureUrl ?? '').isNotEmpty)
              Container(
                width: double.infinity,
                height: 280,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage("${product.coverPictureUrl!},"),
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            const SizedBox(height: 16),
            Text(
              product.categories!.first.toUpperCase(),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Text(
              product.name ?? '',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  '\$${product.price ?? '0'}',
                  style: AppTextSty.blackBold20.copyWith(
                    color: AppColors.primaryColor,
                  ),
                ),
                const SizedBox(width: 10),
                if (product.discountPercentage != null)
                  Text(
                    '\$${((product.price ?? 0) * (1 + (product.discountPercentage ?? 0) / 100)).round()}',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'About this item',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              product.description ?? 'No description',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Reviews',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                TextButton.icon(
                  onPressed: () => _showReviewDialog(context),
                  icon: const Icon(Icons.rate_review_outlined),
                  label: Text(
                    'Write',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.greyColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            Text(
                              _averageRating.toString(),
                              style: AppTextSty.blackBold20.copyWith(
                                color: AppColors.primaryColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            _buildRatingStars(_averageRating),
                            const SizedBox(height: 8),
                            Text(
                              '$_totalReviews reviews',
                              style: Theme.of(
                                context,
                              ).textTheme.bodySmall!.copyWith(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: _ratingDistribution
                              .map(
                                (rating) => _buildRatingBar(
                                  context,
                                  rating['stars'],
                                  rating['percentage'],
                                  '${(rating['percentage'] * 100).round()}%',
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ..._reviews.map((r) => _buildReviewTile(r)).toList(),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      final cart = context.read<CartCubit>();
                      cart.addItem(product.id!, 2);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${product.name} added to cart'),
                        ),
                      );
                      Navigator.pushNamed(context, AppRoute.cart);
                    },
                    icon: Icon(
                      Icons.add_shopping_cart,
                      color: AppColors.whiteColor,
                    ),
                    label: Text('Add to cart', style: AppTextSty.whiteBold16),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  onPressed: () =>
                      _favoriteStatus.value = !_favoriteStatus.value,
                  icon: ValueListenableBuilder<bool>(
                    valueListenable: _favoriteStatus,
                    builder: (_, fav, __) => Icon(
                      fav ? Icons.favorite : Icons.favorite_border,
                      color: fav ? Colors.red : AppColors.greyColor,
                      size: 28,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ✅ دوال المساعدة كما هي (بدون أي تغيير في الشكل)
  Widget _buildReviewTile(Map<String, dynamic> r) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: AppColors.primaryColor.withOpacity(0.1),
            child: Text(
              (r['author'] ?? 'U').toString().substring(0, 1).toUpperCase(),
              style: AppTextSty.blackBold20.copyWith(
                color: AppColors.primaryColor,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      r['author'] ?? '',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(r['date'] ?? '', style: AppTextSty.greyRegular14),
                  ],
                ),
                const SizedBox(height: 6),
                if (r['rating'] != null)
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        index < r['rating'] ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 16,
                      );
                    }),
                  ),
                const SizedBox(height: 6),
                Text(
                  r['comment'] ?? '',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingStars(double rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < rating.floor()) {
          return const Icon(Icons.star, color: Colors.amber, size: 16);
        } else if (index == rating.floor() && rating % 1 > 0) {
          return const Icon(Icons.star_half, color: Colors.amber, size: 16);
        }
        return const Icon(Icons.star_border, color: Colors.amber, size: 16);
      }),
    );
  }

  Widget _buildRatingBar(
    BuildContext context,
    int stars,
    double percentage,
    String label,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 32,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$stars',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium!.copyWith(fontSize: 14),
                ),
                const Icon(Icons.star, size: 12, color: Colors.amber),
              ],
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percentage,
                backgroundColor: AppColors.greyColor.withOpacity(0.2),
                color: Colors.amber,
                minHeight: 8,
              ),
            ),
          ),
          SizedBox(
            width: 40,
            child: Text(
              label,
              textAlign: TextAlign.end,
              style: AppTextSty.greyRegular14,
            ),
          ),
        ],
      ),
    );
  }

  void _showReviewDialog(BuildContext context) {
    final commentCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final ratingNotifier = ValueNotifier<double>(5.0);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        title: Text(
          'Write a review',
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            fontSize: 18, // أصغر شوية
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Rate this product',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                ValueListenableBuilder<double>(
                  valueListenable: ratingNotifier,
                  builder: (context, rating, _) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return IconButton(
                          iconSize: 28, // حجم النجوم متناسب
                          padding: EdgeInsets.zero, // تقليل المسافات بين النجوم
                          constraints:
                              const BoxConstraints(), // لتقليل المساحة المحجوزة
                          icon: Icon(
                            index < rating ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                          ),
                          onPressed: () => ratingNotifier.value = index + 1.0,
                        );
                      }),
                    );
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: commentCtrl,
                  maxLines: 4,
                  style: const TextStyle(fontSize: 14), // تصغير الخط
                  decoration: InputDecoration(
                    hintText: 'Write your review here...',
                    hintStyle: const TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.primaryColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppColors.primaryColor,
                        width: 1.5,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),
                  validator: (v) => (v == null || v.trim().length < 10)
                      ? 'Review must be at least 10 characters'
                      : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: AppTextSty.greyRegular14),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                _addReview(commentCtrl.text.trim(), ratingNotifier.value);
                Navigator.pop(context);
              }
            },
            child: Text(
              'Submit',
              style: AppTextSty.whiteBold16.copyWith(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
