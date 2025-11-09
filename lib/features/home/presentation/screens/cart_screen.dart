import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:nti_final_project_new/features/home/presentation/cubit/cart_cubit.dart';

import '/core/utils/app_style/color_app.dart';
import '/core/utils/app_style/text_style_app.dart';
import '../cubit/cart_state.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController couponController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<CartCubit>().loadCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shopping Cart"),
        centerTitle: true,
        toolbarHeight: 70,
        titleTextStyle: Theme.of(
          context,
        ).textTheme.bodyLarge!.copyWith(fontSize: 21),
      ),
      body: BlocListener<CartCubit, CartState>(
        listener: (context, state) {
          if (state is CartLoaded && state.message != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message!),
                backgroundColor: state.message!.contains("success")
                    ? Colors.green
                    : Colors.red,
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },
        child: BlocBuilder<CartCubit, CartState>(
          builder: (context, state) {
            if (state is CartLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CartError) {
              return Center(child: Text(state.message));
            } else if (state is CartLoaded) {
              final cart = state.cart;

              if (cart.cartItems.isEmpty) {
                return Center(
                  child: Lottie.asset(
                    'assets/lottie/nodata.json',
                    width: 200,
                    height: 200,
                    fit: BoxFit.contain,
                  ),
                );
              }

              double subtotal = cart.subtotal;
              double total = cart.total;

              return Column(
                children: [
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await context.read<CartCubit>().loadCart();
                      },
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              // 🛒 المنتجات
                              ...cart.cartItems.map((item) {
                                return Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          child: Image.network(
                                            item.productCoverUrl,
                                            width: 80,
                                            height: 80,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item.productName,
                                                style: Theme.of(
                                                  context,
                                                ).textTheme.bodyMedium,
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                "\$${item.finalPricePerUnit.toStringAsFixed(2)} per unit",
                                                style: Theme.of(
                                                  context,
                                                ).textTheme.bodySmall,
                                              ),
                                              const SizedBox(height: 8),
                                              Row(
                                                children: [
                                                  IconButton(
                                                    icon: const Icon(
                                                      Icons
                                                          .remove_circle_outline,
                                                    ),
                                                    color:
                                                        AppColors.primaryColor,
                                                    onPressed: () => context
                                                        .read<CartCubit>()
                                                        .decrementItem(
                                                          item.itemId,
                                                          1,
                                                        ),
                                                  ),
                                                  Container(
                                                    width: 35,
                                                    height: 30,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            6,
                                                          ),
                                                    ),
                                                    child: Text(
                                                      "${item.quantity}",
                                                      style: Theme.of(
                                                        context,
                                                      ).textTheme.bodyMedium,
                                                    ),
                                                  ),
                                                  IconButton(
                                                    icon: const Icon(
                                                      Icons.add_circle_outline,
                                                    ),
                                                    color:
                                                        AppColors.primaryColor,
                                                    onPressed: () => context
                                                        .read<CartCubit>()
                                                        .addItem(
                                                          item.productId,
                                                          1,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete_outline,
                                          ),
                                          color: Colors.red,
                                          onPressed: () => context
                                              .read<CartCubit>()
                                              .deleteItem(item.itemId),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),

                              const SizedBox(height: 12),

                              // 🎟️ الكوبون
                              Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 3,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: couponController,
                                          style: const TextStyle(fontSize: 14),
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "Enter coupon code",
                                            hintStyle: TextStyle(fontSize: 14),
                                          ),
                                        ),
                                      ),
                                      ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              AppColors.primaryColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                        ),
                                        onPressed: () {
                                          context.read<CartCubit>().applyCoupon(
                                            couponController.text.trim(),
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.discount_outlined,
                                        ),
                                        label: const Text("Apply"),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 100),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // ✅ أسفل الصفحة (Total + Shipping + Checkout)
                  Card(
                    elevation: 2,
                    shadowColor: Colors.black,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Subtotal:",
                                style: TextStyle(
                                  fontSize: 14, // أصغر من 16
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                "\$${subtotal.toStringAsFixed(2)}",
                                style: const TextStyle(
                                  fontSize: 14, // أصغر
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                "Shipping:",
                                style: TextStyle(
                                  fontSize: 14, // أصغر
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                "\$25.00",
                                style: TextStyle(
                                  fontSize: 14, // أصغر
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Total:",
                                style: TextStyle(
                                  fontSize: 16, // أصغر من 18
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "\$${total.toStringAsFixed(2)}",
                                style: const TextStyle(
                                  fontSize: 16, // أصغر
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              minimumSize: const Size.fromHeight(
                                45,
                              ), // أقل من 50
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {},
                            child: Text(
                              "Proceed to Checkout",
                              style: AppTextSty.whiteBold16.copyWith(
                                fontSize: 14,
                              ), // قللت من 16 لـ 14
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
