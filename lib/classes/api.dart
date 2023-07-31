import 'dart:convert';
import 'package:apollo_manager/enums/which_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'dart:core';

class Api {
  final EncryptedSharedPreferences _storage = EncryptedSharedPreferences();

  Future<dynamic> login(String username, String password) async {
    try {
      final uri = _getUri("/token/authorize");
      final response = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode({
          "username": username,
          "password": password,
        }),
      );

      return json.decode(response.body);
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
      final uri = _getUri("/token/validate");
      final response = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
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
      final uri = _getUri(route);
      final response = await http.post(uri,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
          body: jsonEncode(body));

      return json.decode(response.body);
    } catch (e) {
      debugPrint("Error (at post request): $e");
      return [];
    }
  }

  dynamic _getUri(String uri, [Map<String, dynamic>? params]) {
    // Uri uri = Uri.http("${dotenv.env['API_URL']}$uri");
    Uri url = Uri.http(dotenv.env['API_BASE_URL']!,
        "/api/${dotenv.env['API_VERSION']!}$uri", params);

    return url;
  }

  Future<dynamic> get(String route) async {
    final token = await _storage.getString("token");

    if (token == "") {
      return [];
    }

    try {
      final uri = _getUri(route);
      final response = await http.get(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      return json.decode(response.body);
    } catch (e) {
      debugPrint("Error at Api.get: $e");
      return [];
    }
  }

  Future<List<dynamic>> fetchData({
    required WhichData whichData,
    String? query,
    Map<String, dynamic>? params,
  }) async {
    final token = await _storage.getString("token");

    if (token == "") {
      return [];
    }

    try {
      final url = _getUri(whichData.endpoint, params);
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      dynamic responseData = json.decode(response.body);

      if (responseData["code"] != 200) {
        debugPrint('Error fetching data: ${responseData["message"]}');
        return [];
      }

      List<dynamic> data =
          responseData["data"].map((json) => whichData.fromJson(json)).toList();

      return data;
    } catch (e) {
      debugPrint("Error at fetching $whichData: $e");
      return [];
    }
  }
}
