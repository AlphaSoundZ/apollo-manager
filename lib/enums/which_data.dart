import '../models/class_model.dart';
import '../models/device_model.dart';
import '../models/user_model.dart';
import '../models/usercard_model.dart';
import '../models/token_model.dart';
import '../models/devicetype_model.dart';

enum WhichData { users, devices, deviceTypes, classes, usercards, tokens }

extension WhichDataExtension on WhichData {
  dynamic fromJson(Map<String, dynamic> json) {
    switch (this) {
      case WhichData.users:
        return User.fromJson(json);
      case WhichData.devices:
        return Device.fromJson(json);
      case WhichData.deviceTypes:
        return DeviceType.fromJson(json);
      case WhichData.classes:
        return ClassModel.fromJson(json);
      case WhichData.usercards:
        return Usercard.fromJson(json);
      case WhichData.tokens:
        return Token.fromJson(json);
    }
  }

  String get endpoint {
    switch (this) {
      case WhichData.users:
        return "/user";
      case WhichData.devices:
        return "/device";
      case WhichData.deviceTypes:
        return "/device/type";
      case WhichData.classes:
        return "/user/class";
      case WhichData.usercards:
        return "/usercard";
      case WhichData.tokens:
        return "/token";
    }
  }
}
