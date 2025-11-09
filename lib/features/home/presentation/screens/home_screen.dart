import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nti_final_project_new/core/utils/app_constant/routes.dart';
import 'package:nti_final_project_new/core/utils/app_style/color_app.dart';
import 'package:nti_final_project_new/features/home/presentation/cubit/home_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../cubit/home_cubit.dart';
import '../widgets/carousel_widget.dart';
import '../widgets/custom_card_item_home.dart';
import '../widgets/custom_main_items.dart';
import '../widgets/custom_voice_widget.dart';

class HomeScreens extends StatefulWidget {
  const HomeScreens({super.key});

  @override
  State<HomeScreens> createState() => _HomeScreensState();
}

class _HomeScreensState extends State<HomeScreens> {
  TextEditingController searhController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // تحميل المنتجات عند فتح الصفحة
    context.read<HomeCubit>().getAllItems();
  }

  Future<List<dynamic>> getCategory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("accessToken");
      if (token == null) throw Exception('User not logged in');

      final response = await Dio().get(
        "https://accessories-eshop.runasp.net/api/categories",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data["categories"];
      } else {
        throw Exception("Failed to load categories");
      }
    } catch (e) {
      print("Error fetching categories: $e");
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          toolbarHeight: 80,
          leading: IconButton(
            icon: const Icon(Icons.list_sharp),
            onPressed: () {},
          ),
          title: Text(
            "Modenique",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          actions: [
            InkWell(
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.withOpacity(0.3)),
                ),
                child: Icon(
                  Icons.notifications,
                  size: 22,
                  color: AppColors.primaryColor,
                ),
              ),
              onTap: () {
                Navigator.pushNamed(context, AppRoute.notificationScreen);
              },
            ),
            const SizedBox(width: 20),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                TextFormField(
                  controller: searhController,
                  style: const TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                    hintText: "Search for Products",
                    prefixIcon: IconButton(
                      onPressed: () {
                        if (searhController.text.trim().isNotEmpty) {
                          Navigator.pushNamed(
                            context,
                            AppRoute.searchScreen,
                            arguments: searhController.text,
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Please say or type something to search",
                              ),
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.search),
                    ),
                    suffixIcon: VoiceInputWidget(
                      onTextRecognized: (text) {
                        setState(() {
                          searhController.text = text;
                        });
                      },
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 8,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const CarouselWidget(),
                const SizedBox(height: 18),
                Text(
                  "Categories",
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium!.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 15),
                FutureBuilder<List<dynamic>>(
                  future: getCategory(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.black),
                      );
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    }
                    if (snapshot.hasData) {
                      final categories = snapshot.data!;
                      return SizedBox(
                        height: 90,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            return CustomMainItems(
                              image: categories[index]["coverPictureUrl"] ?? "",
                              title: categories[index]["name"] ?? "",
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoute.productScreen,
                                );
                              },
                            );
                          },
                        ),
                      );
                    }
                    return const Center(child: Text("No data found"));
                  },
                ),
                const SizedBox(height: 20),
                // عرض أول 5 أو 6 منتجات
                Text(
                  "Featured Products",
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium!.copyWith(fontSize: 16),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 230,
                  child: BlocBuilder<HomeCubit, HomeState>(
                    builder: (context, state) {
                      if (state is GetProductsLodingState) {
                        return const Center(
                          child: CircularProgressIndicator(color: Colors.black),
                        );
                      }
                      if (state is GetProductsFailerState) {
                        return Center(
                          child: Text("Error: ${state.errorMessage}"),
                        );
                      }
                      if (state is GetProductsSucessState) {
                        final products = state.products;
                        final displayCount = products.length < 6
                            ? products.length
                            : 6;
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: displayCount,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: CustomCardItemHome(
                                item: products[index],
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    AppRoute.productScreen,
                                    arguments: products[index],
                                  );
                                },
                              ),
                            );
                          },
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
