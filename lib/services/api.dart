import 'package:apollo_manager/enums/which_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:dio/dio.dart';
import 'dart:core';

class Api {
  final EncryptedSharedPreferences _storage = EncryptedSharedPreferences();
  final dio = Dio(BaseOptions(
    baseUrl: dotenv.env["API_BASE_URL"]!,
    contentType: "application/json",
  ));

  Future<dynamic> login(String username, String password) async {
    try {
      final response = await dio.post(
        "/token/authorize",
        data: {
          "username": username,
          "password": password,
        },
      );

      return response.data;
    } catch (e) {
      debugPrint("Error at login: $e");
      return {
        "status": "unexpected_error",
        "code": 500,
        "message": "Error: $e",
      };
    }
  }

  Future<bool> isLoggedIn() async {
    final EncryptedSharedPreferences storage = EncryptedSharedPreferences();
    final token = await storage.getString("token");

    if (token == "") {
      return false;
    }

    try {
      final response = await dio.post(
        "/token/validate",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint("Error (at checking login): $e");
      return false;
    }
  }

  void logout() {
    _storage.setString("token", "");
  }

  Future<dynamic> post(String route, Object body) async {
    final token = await _storage.getString("token");

    try {
      final response = await dio.post(
        route,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
        data: body,
      );

      return response.data;
    } catch (e) {
      debugPrint("Error (at post request): $e");
      return [];
    }
  }

  Future<dynamic> get(String route) async {
    final token = await _storage.getString("token");

    if (token == "") {
      return [];
    }

    try {
      final response = await dio.get(
        route,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );

      return response.data;
    } catch (e) {
      debugPrint("Error at Api.get: $e");
      return [];
    }
  }

  Future<List<dynamic>> fetchData({
    required WhichData whichData,
    Map<String, dynamic>? params,
  }) async {
    final token = await _storage.getString("token");

    if (token == "") {
      return [];
    }

    debugPrint(params.toString());

    try {
      final response = await dio.get(
        whichData.endpoint,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
        queryParameters: params,
      );

      if (response.statusCode != 200) {
        debugPrint('Error fetching data: ${response.data["message"]}');
        return [];
      }

      List<dynamic> data = response.data["data"]
          .map((json) => whichData
              .fromJson(json.containsKey("accordance") ? json["data"] : json))
          .toList();

      return data;
    } catch (e) {
      debugPrint("Error at fetching $whichData: $e");
      return [];
    }
  }
}
