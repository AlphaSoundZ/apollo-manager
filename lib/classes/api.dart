import 'dart:convert';
import 'package:apollo_manager/enums/which_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import '../models/user_model.dart';
import '../models/device_model.dart';
import '../models/class_model.dart';
import '../models/usercard_model.dart';
import '../models/token_model.dart';

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

  dynamic _getUri(String uri) {
    return Uri.parse("${dotenv.env['API_URL']}$uri");
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

  Future<List<dynamic>> fetchData(WhichData whichData) async {
    switch (whichData) {
      case WhichData.users:
        return await fetchUsers();
      case WhichData.devices:
        return await fetchDevices();
      case WhichData.classes:
        return await fetchClasses();
      case WhichData.usercards:
        return await fetchUsercards();
      case WhichData.tokens:
        return await fetchTokens();
      default:
        return [];
    }
  }

  Future<List<User>> fetchUsers() async {
    final token = await _storage.getString("token");

    if (token == "") {
      return [];
    }

    try {
      final uri = _getUri("/user");
      final response = await http.get(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      List<User> users = [];
      dynamic responseData = json.decode(response.body);

      if (responseData["code"] != 200) {
        debugPrint('token: $token');
        debugPrint('Error fetching data: ${responseData["message"]}');
        return [];
      }

      for (var user in responseData["data"]) {
        users.add(User(
          id: user["id"] as int,
          name: Name(
            firstname: user["firstname"],
            lastname: user["lastname"],
          ),
          className: user["class"]["name"],
        ));
      }

      return users;
    } catch (e) {
      debugPrint("Error at fetching users: $e");
      return [];
    }
  }

  Future<List<Device>> fetchDevices() async {
    final token = await _storage.getString("token");

    if (token == "") {
      return [];
    }

    try {
      final uri = _getUri("/device");
      final response = await http.get(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      List<Device> devices = [];
      dynamic responseData = json.decode(response.body);

      if (responseData["code"] != 200) {
        debugPrint('token: $token');
        debugPrint('Error fetching data: ${responseData["message"]}');
        return [];
      }

      for (var device in responseData["data"]) {
        devices.add(Device(
          id: device["id"],
          uid: device["uid"] as String,
          deviceType: device["type"]["name"],
        ));
      }

      return devices;
    } catch (e) {
      debugPrint("Error: $e");
      return [];
    }
  }

  Future<List<Usercard>> fetchUsercards() async {
    final token = await _storage.getString("token");

    if (token == "") {
      return [];
    }

    try {
      final uri = _getUri("/usercard");
      final response = await http.get(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      List<Usercard> usercards = [];
      dynamic responseData = json.decode(response.body);

      if (responseData["code"] != 200) {
        debugPrint('token: $token');
        debugPrint('Error fetching data: ${responseData["message"]}');
        return [];
      }

      for (var usercard in responseData["data"]) {
        usercards.add(Usercard(
          id: usercard["id"],
          uid: usercard["uid"].toString(),
          usercardType: usercard["type"]["name"],
        ));
      }

      return usercards;
    } catch (e) {
      debugPrint("Error: $e");
      return [];
    }
  }

  Future<List<ClassModel>> fetchClasses() async {
    final token = await _storage.getString("token");

    if (token == "") {
      return [];
    }

    try {
      final uri = _getUri("/user/class");
      final response = await http.get(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      List<ClassModel> classes = [];
      dynamic responseData = json.decode(response.body);

      if (responseData["code"] != 200) {
        debugPrint('token: $token');
        debugPrint('Error fetching data: ${responseData["message"]}');
        return [];
      }

      for (var class_ in responseData["data"]) {
        classes.add(ClassModel(
          id: class_["id"] as int,
          name: class_["name"] as String,
          amount: class_["amount"] as int,
        ));
      }

      return classes;
    } catch (e) {
      debugPrint("Error: $e");
      return [];
    }
  }

  Future<List<Token>> fetchTokens() async {
    final token = await _storage.getString("token");

    if (token == "") {
      return [];
    }

    try {
      final uri = _getUri("/token");
      final response = await http.get(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      List<Token> tokens = [];
      dynamic responseData = json.decode(response.body);

      if (responseData["code"] != 200) {
        debugPrint('token: $token');
        debugPrint('Error fetching data: ${responseData["message"]}');
        return [];
      }

      for (var token in responseData["data"]) {
        tokens.add(Token(
          id: token["token_id"] as int,
          lastChange: token["last_change"],
          permissionIds: token["permission_id"],
          permissionTexts: token["permission_text"],
          user: User(
            id: token["user"]["id"],
            name: Name(
              firstname: token["user"]["firstname"],
              lastname: token["user"]["lastname"],
            ),
            className: token["user"]["class"]["name"],
          ),
          username: token["username"],
        ));
      }

      return tokens;
    } catch (e) {
      debugPrint("Error: $e");
      return [];
    }
  }
}
