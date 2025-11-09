import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'result_model.dart'; // الموديل الجديد

class ImageSearchController extends GetxController {
  File? file;
  var statusRequest = Rxn<String>();
  List<AiSearchResultModel> aiSearchResults = [];

  Future<void> chooseImage(File pickedFile) async {
    file = pickedFile;
    update();
  }

  void removeImage() {
    file = null;
    aiSearchResults.clear();
    update();
  }

  /// جلب تفاصيل المنتج من API خارجي
  Future<Map<String, dynamic>?> fetchProductDetails(int productId) async {
    try {
      final response = await http.get(
        Uri.parse(
          "https://accessories-eshop.runasp.net/api/products/$productId",
        ),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print("Error fetching product details: $e");
    }
    return null;
  }

  /// رفع الصورة للـ Flask والحصول على النتائج
  Future<void> uploadImage() async {
    if (file == null) return;
    statusRequest.value = "loading";
    aiSearchResults.clear();
    update();

    try {
      final bytes = await file!.readAsBytes();
      final base64Image = base64Encode(bytes);

      final response = await http.post(
        Uri.parse('http://192.168.141.157:8080/search'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'image_base64': base64Image, 'k': 5}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final results = data['results'] as List;

        for (var result in results) {
          final productId = result['items_id']; // ID اللي جاي من Flask
          final productDetails = await fetchProductDetails(productId);

          if (productDetails != null) {
            aiSearchResults.add(
              AiSearchResultModel(
                productId: productId,
                similarityScore: (result['similarity_score'] ?? 0).toDouble(),
                itemsImage: productDetails['coverPictureUrl'] ?? '',
                itemsName: productDetails['name'] ?? '',
                itemsDesc: productDetails['description'] ?? '',
                itemsPrice: (productDetails['price'] ?? 0).toDouble(),
              ),
            );
          }
        }

        statusRequest.value = "success";
      } else {
        statusRequest.value = "error";
      }
    } catch (e) {
      print("Error uploading image: $e");
      statusRequest.value = "error";
    }

    update();
  }
}
