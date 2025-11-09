import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/notification_model.dart';
import '../models/product_model.dart';

class HomeApiServices {
  Dio dio = Dio();
  Future<List<ProductModels>> getItemsData() async {
    final response = await dio.get(
      "https://accessories-eshop.runasp.net/api/products",
    );
    final List products = response.data['items'];
    return products.map((e) => ProductModels.fromJson(e)).toList();
  }

  Future<List<dynamic>> getCategory() async {
    Response response =
        await dio.get("https://dummyjson.com/products/categories");
    print("_____________________________$response");
    List<dynamic> products = response.data;
    print(products);

    return products;
  }

  Future<List<NotificationModel>> getNotifications() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString("accessToken");

  if (token == null) {
    throw Exception("Auth token not found");
  }

  Response response = await dio.get(
    "https://accessories-eshop.runasp.net/api/notifications",
    options: Options(
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    ),
  );

  print("Notifications Response: ${response.data}");

  
  final notificationsData = response.data['notifications']['items'];

  if (notificationsData is List) {
    return notificationsData
        .map((e) => NotificationModel.fromJson(e))
        .toList();
  } else {
    return [];
  }
}
}
