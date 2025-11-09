import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:nti_final_project_new/core/utils/app_style/color_app.dart';

import '../cubit/search_cubit.dart';
import '../cubit/search_state.dart';
import '../widgets/custom_voice_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool _dataLoaded = false;
  String? initialQuery;

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final cubit = context.read<SearchCubit>();
      await cubit.getAllProducts();

      initialQuery = ModalRoute.of(context)?.settings.arguments as String?;
      if (initialQuery != null && initialQuery!.isNotEmpty && !_dataLoaded) {
        searchController.text = initialQuery!;
        cubit.searchProduct(initialQuery!);
        _dataLoaded = true;
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SearchCubit>();

    return Scaffold(
      appBar: AppBar(title: const Text("Search Products"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontSize: 13,
              ), // حجم نص الكتابة داخل التكست فيلد
              decoration: InputDecoration(
                labelText: "Search for Products",
                labelStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 12,
                ), // حجم النص بتاع اللابل
                prefixIcon: const Icon(Icons.search, size: 22),
                suffixIcon: VoiceInputWidget(
                  onTextRecognized: (text) {
                    searchController.text = text;
                    cubit.searchProduct(text);
                  },
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: AppColors.primaryColor),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: AppColors.primaryColor,
                    width: 2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: AppColors.primaryColor,
                    width: 2,
                  ),
                ),
              ),
              onChanged: (value) {
                cubit.searchProduct(value);
              },
            ),

            const SizedBox(height: 20),
            Expanded(
              child: BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) {
                  if (state is SearchLoadingState) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is SearchInitialState) {
                    return Center(
                      child: ClipOval(
                        child: Lottie.asset(
                          'assets/lottie/nodata.json',
                          width: 200,
                          height: 200,
                          fit: BoxFit.contain,
                        ),
                      ),
                    );
                  } else if (state is SearchLoadedState) {
                    if (state.products.isEmpty) {
                      return Center(
                        child: ClipOval(
                          child: Lottie.asset(
                            'assets/lottie/nodata.json',
                            width: 200,
                            height: 200,
                            fit: BoxFit.contain,
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: state.products.length,
                      itemBuilder: (context, index) {
                        final product = state.products[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 8,
                          ),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            leading: product.coverPictureUrl != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      product.coverPictureUrl!,
                                      width: 40,
                                      height: 40,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : const Icon(
                                    Icons.image_not_supported,
                                    size: 30,
                                  ),
                            title: Text(
                              product.name ?? "Unnamed Product",
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text(
                              "${product.price ?? 0} EGP",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is SearchErrorState) {
                    return Center(child: Text("Error: ${state.error}"));
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
