import '../enums/which_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'dart:core';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../models/get_response_model.dart';

class Api {
  final EncryptedSharedPreferences _storage = EncryptedSharedPreferences();
  late final dio = Dio(BaseOptions(
    baseUrl: dotenv.env["API_BASE_URL"]!,
    contentType: "application/json",
    validateStatus: (status) {
      return status! < 500;
    },
  ))
    // customization
    ..interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: false,
      error: true,
      compact: true,
    ))
    ..interceptors.add(InterceptorsWrapper(
      onError: (DioException error, handler) {
        if (error.response?.statusCode == 401) {
          // logout
          logout();
          Get.offAllNamed("/login");
        }

        if (error.response == null) {
          // can't reach server because of not being in the same network
          return handler.resolve(Response(
            requestOptions: error.requestOptions,
            data: {
              "message": "Can't reach server",
              "code": 503,
              "status": "NETWORK_ERROR",
            },
            statusCode: 503,
            statusMessage: "Can't reach server",
          ));
        }

        return handler.resolve(error.response!);
        // return handler.next(error);
      },
    ));

  Future<dynamic> login(String username, String password) async {
    final response = await dio.post(
      "/token/authorize",
      data: {
        "username": username,
        "password": password,
      },
    );

    if (response.statusCode == 200) {
      // save payload in prefs
      await _storage.setString("username", username);
      await _storage.setString("firstName", response.data["user"]["firstname"]);
      await _storage.setString("lastName", response.data["user"]["lastname"]);
      await _storage.setString(
          "usercardId", response.data["user"]["usercard"]["id"].toString());
      await _storage.setString(
          "usercardUid", response.data["user"]["usercard"]["uid"].toString());
      await _storage.setString("token", response.data["jwt"]);
      await _storage.setString(
          "userId", response.data["user"]["id"].toString());
    }

    return response.data;
  }

  Future<List<int>> getPermissions() async {
    String token = await _storage.getString("token");

    if (token == "") {
      return [];
    }

    final payload = Jwt.parseJwt(token);

    return payload["permissions"].cast<int>();
  }

  Future<String> isLoggedIn() async {
    String? token = await _storage.getString("token");
    debugPrint("token: $token");

    if (token == "") {
      return "";
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
        return token;
      } else {
        return "";
      }
    } catch (e) {
      debugPrint("Error (at checking login): $e");
      return "";
    }
  }

  Future<void> logout() async {
    await _storage.remove("token");
    await _storage.remove("userId");
    await _storage.remove("username");
    await _storage.remove("firstName");
    await _storage.remove("lastName");
  }

  Future<dynamic> delete(String route, Object body) async {
    final token = await _storage.getString("token");

    try {
      final response = await dio.delete(
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
      debugPrint("Error (at delete request): $e");
      return [];
    }
  }

  Future<dynamic> patch(String route, Object body) async {
    final token = await _storage.getString("token");

    try {
      final response = await dio.patch(
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
      debugPrint("Error (at patch request): $e");
      return [];
    }
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

  Future<GetResponseBody> get(
    BuildContext context, {
    required route,
    WhichData? whichData,
    Map<String, dynamic>? params,
  }) async {
    final token = await _storage.getString("token");

    if (token == "") {
      return GetResponseBody.empty();
    }

    final response = await dio.get(
      route,
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
      queryParameters: params,
    );

    List<dynamic> data = [];

    // if whichData is not null, then we need to map the data to the model

    if (whichData != null) {
      if (response.data["data"] == null) {
        return GetResponseBody.empty();
      }

      data = response.data["data"]
          .map((json) => whichData.fromJson(
              context, json.containsKey("accordance") ? json["data"] : json))
          .toList();
    } else {
      data = response.data["data"];
    }

    // create response body model
    GetResponseBody responseBody = GetResponseBody.fromJson(
        {...response.data, "data": data, "params": params});

    return responseBody;
  }
}
