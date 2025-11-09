import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/services/cache/cache_helper.dart';

class ApiServices {
  Dio dio = Dio();
  Future<Response?> createNewAcount(
      String email, password, firstname, lastname) async {
    try {
      Response response = await dio.post(
          "https://accessories-eshop.runasp.net/api/auth/register",
          data: {
            "email": email,
            "password": password,
            "firstName": firstname,
            "lastName": lastname
          });

      print("------------------------------$response");
      return response;
    } on DioException catch (e) {
      print(" DIO ERROR: ${e.response?.data}");
    } catch (e) {
      print("-----------------$e");
    }
    return null;
  }

  Future<Response?> checkeAcount(String email, password) async {
    try {
      final Response response = await dio.post(
          "https://accessories-eshop.runasp.net/api/auth/login",
          data: {"email": email, "password": password});
      print(response);
      return response;
    } on DioException catch (e) {
      print("----------------$e");
    } catch (e) {
      print("error______________________$e");
    }
    return null;
  }

  Future<Response> sendOTP(String email, String otp) async {
    return await dio.post(
      "https://accessories-eshop.runasp.net/api/auth/validate-otp",
      data: {"email": email, "otp": otp},
    );
  }

  Future<Response> resendOTP(String email) async {
    return await dio.post(
      "https://accessories-eshop.runasp.net/api/auth/resend-otp",
      data: {"email": email},
    );
  }

  Future<Response?> forgetPssword(String email) async {
    try {
      Response response = await dio.post(
          "https://accessories-eshop.runasp.net/api/auth/forgot-password",
          data: {"email": email});
      print(response);
      return response;
    } on DioException catch (e) {
      print("------------------$e");
    } catch (e) {
      print("------------------$e");
    }
    return null;
  }

  Future<Response> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    try {
      final response = await dio.post(
        "https://accessories-eshop.runasp.net/api/auth/reset-password",
        data: {
          "email": email,
          "otp": otp,
          "newPassword": newPassword,
        },
      );
      return response;
    } on DioException catch (e) {
      throw e.response?.data ?? e.message;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Response?> logout() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("accessToken");

    if (token == null) throw Exception("No token found");

    final response = await dio.post(
      "https://accessories-eshop.runasp.net/api/auth/logout",
      options: Options(
        headers: {"Authorization": "Bearer $token"},
      ),
    );

    print("Logout response: ${response.data}");
    return response;
  } on DioException catch (e) {
    print("------------------------ Dio Error: ${e.response?.data ?? e.message}");
    rethrow;
  } catch (e) {
    print("------------------------------- Unexpected Error: $e");
    rethrow;
  }
}


  Future<Response?> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    try {
      final token = await CacheHelper().getData(key: "accessToken");
      print("Token: $token");

      final response = await dio.post(
        "https://accessories-eshop.runasp.net/api/auth/change-password",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
        ),
        data: {
          "currentPassword": currentPassword,
          "newPassword": newPassword,
          "confirmNewPassword": confirmNewPassword,
        },
      );

      print("Response: ${response.data}");
      return response;
    } on DioException catch (e) {
      print("------------------------ Dio Error: ${e.response?.data}");
      print("Status code: ${e.response?.statusCode}");
    } catch (e) {
      print("------------------------------- General Error: $e");
    }
    return null;
  }
}
