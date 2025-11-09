import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nti_final_project_new/core/utils/app_constant/routes.dart';

import '../../data/models/product_model.dart';
import '../cubit/cart_cubit.dart';
import '../cubit/favourite_cubit.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../widgets/custom_card_item.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  Dio dio = Dio();
  List<ProductModels> localProducts = [];

  Future<void> deletItem(String id) async {
    final Response response = await dio.delete(
      "https://accessories-eshop.runasp.net/api/products/$id",
    );
    print("--------------------------$response");
  }

  @override
  Widget build(BuildContext context) {
    final favCubit = context.read<FavoriteCubit>();

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        elevation: 0.01,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Products",
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 21),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is GetProductsLodingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GetProductsSucessState) {
            if (localProducts.isEmpty) {
              localProducts = List.from(state.products);
            }

            return BlocBuilder<FavoriteCubit, List>(
              builder: (context, favorites) {
                return GridView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: localProducts.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15,
                    childAspectRatio: 0.62,
                  ),
                  itemBuilder: (context, index) {
                    final product = localProducts[index];
                    final isFav = context.watch<FavoriteCubit>().isFavorite(
                      product,
                    );

                    return CustomCardItem(
                      item: product,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoute.detailsScreen,
                          arguments: product,
                        );
                      },
                      onTapFav: () => favCubit.toggleFavorite(product),
                      isFavourite: isFav,
                      onPressedDelet: () async {
                        final id = product.id;

                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              title: const Text(
                                "Confirm Delete",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              content: const Text(
                                "Are you sure you want to delete this product?",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context, false);
                                  },
                                  child: const Text("Cancel"),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context, true);
                                  },
                                  child: const Text("Delete"),
                                ),
                              ],
                            );
                          },
                        );

                        if (confirm == true) {
                          await deletItem(id!);

                          setState(() {
                            localProducts.removeAt(index);
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Product deleted successfully"),
                              backgroundColor: Colors.redAccent,
                              duration: Duration(seconds: 3),
                            ),
                          );
                        }
                      },
                      onPressedAddtoCart: () {
                        final cart = context.read<CartCubit>();
                        cart.addItem(product.id!, 2);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${product.name} added to cart'),
                          ),
                        );
                        Navigator.pushNamed(context, AppRoute.cart);
                      },
                    );
                  },
                );
              },
            );
          } else if (state is GetProductsFailerState) {
            return Center(child: Text(state.errorMessage));
          }
          return const Center(child: Text("No Data Found"));
        },
      ),
    );
  }
}
