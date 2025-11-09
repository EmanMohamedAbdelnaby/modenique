import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/utils/app_constant/routes.dart';
import '../cubit/cart_cubit.dart';
import '../cubit/favourite_cubit.dart';
import '../widgets/custom_card_item.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteCubit = context.watch<FavoriteCubit>();
    final favorites = favoriteCubit.state;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        centerTitle: true,
        title: Text(
          'My Favorites',
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 22),
        ),
      ),
      body: favorites.isEmpty
          ? Center(
              child: ClipOval(
                child: Lottie.asset(
                  'assets/lottie/nodata.json',
                  width: 200,
                  height: 200,
                  fit: BoxFit.contain,
                ),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: favorites.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                childAspectRatio: 0.62,
              ),
              itemBuilder: (context, index) {
                return CustomCardItem(
                  item: favorites[index],
                  isFavourite: true,
                  onTapFav: () =>
                      favoriteCubit.toggleFavorite(favorites[index]),
                  onPressedDelet: () async {
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
                    cart.addItem(favorites[index].id!, 2);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${favorites[index].name} added to cart'),
                      ),
                    );
                    Navigator.pushNamed(context, AppRoute.cart);
                  },
                );
              },
            ),
    );
  }
}
