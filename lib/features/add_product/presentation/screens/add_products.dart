import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/app_style/color_app.dart';
import '../../../../core/utils/shared_custom_widget/custom_text_form_field.dart';
import '../../../../core/utils/shared_custom_widget/primary_button_widget.dart';
import '../../../home/data/models/product_model.dart';

class AddProducts extends StatefulWidget {
  const AddProducts({super.key});

  @override
  State<AddProducts> createState() => _AddProductsState();
}

Dio dio = Dio();
GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

TextEditingController nameController = TextEditingController();
TextEditingController nameArabicController = TextEditingController();
TextEditingController descriptionController = TextEditingController();
TextEditingController descriptionArabicController = TextEditingController();
TextEditingController priceController = TextEditingController();
TextEditingController stockController = TextEditingController();
TextEditingController weightController = TextEditingController();
TextEditingController colorController = TextEditingController();
TextEditingController discountController = TextEditingController();
TextEditingController coverUrlController = TextEditingController();

bool isLoading = false;

class _AddProductsState extends State<AddProducts> {
  final String sellerId = "d051dbf3-f5d8-410d-0e50-08de06562562";

  Future<void> addProduct() async {
    setState(() => isLoading = true);

    try {
      final product = ProductModels(
        sellerId: sellerId,
        name: nameController.text,
        description: descriptionController.text,
        arabicName: nameArabicController.text,
        arabicDescription: descriptionArabicController.text,
        coverPictureUrl: coverUrlController.text,
        price: double.tryParse(priceController.text),
        stock: int.tryParse(stockController.text) ?? 0,
        weight: double.tryParse(weightController.text),
        color: colorController.text,
        discountPercentage: int.tryParse(discountController.text),
        categories: ["baf42551-fbdb-4b2e-93b1-c58e14983e7a"],
        productPictures: null,
      );

      final Response response = await dio.post(
        "https://accessories-eshop.runasp.net/api/products",
        data: product.toJson(),
      );

      print(" Product added: ${response.data}");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Product added successfully"),
          backgroundColor: AppColors.primaryColor,
          duration: Duration(seconds: 3),
        ),
      );

      _clearFields();
    } on DioException catch (e) {
      print(" DioException: ${e.response?.data}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text("Error adding product: ${e.response?.data ?? e.message}"),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      print(" Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Unexpected error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _clearFields() {
    nameController.clear();
    nameArabicController.clear();
    descriptionController.clear();
    descriptionArabicController.clear();
    coverUrlController.clear();
    priceController.clear();
    stockController.clear();
    weightController.clear();
    colorController.clear();
    discountController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 75,
          elevation: 0.02,
          centerTitle: true,
          title: Text(
            "Add Product",
            style:
                Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 22),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: SingleChildScrollView(
            child: Form(
              key: _globalKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildField("Product Name", nameController),
                  _buildField("Product Name Arabic", nameArabicController),
                  _buildField("Description", descriptionController,
                      maxLines: 2),
                  _buildField("Description Arabic", descriptionArabicController,
                      maxLines: 2),
                  _buildField("Cover Image URL", coverUrlController),
                  _buildField("Price", priceController),
                  _buildField("Stock", stockController),
                  _buildField("Weight", weightController),
                  _buildField("Color", colorController),
                  _buildField("Discount Percentage", discountController),
                  const SizedBox(height: 20),
                  Center(
                    child: PrimaryButtonWidget(
                      fontsize: 18,
                      buttonColor: AppColors.primaryColor,
                      bootonText: "Add Product",
                      onpressed: () async {
                        if (_globalKey.currentState!.validate()) {
                          await addProduct();
                        }
                      },
                    ),
                  ),
                  if (isLoading)
                    const Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          TextFormeFieldStyle(
            controller: controller,
            maxLin: maxLines,
            validate: (val) => val!.isEmpty ? "Please enter $label" : null,
          ),
        ],
      ),
    );
  }
}
