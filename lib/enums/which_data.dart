import '../models/class_model.dart';
import '../models/device_model.dart';
import '../models/user_model.dart';
import '../models/usercard_model.dart';
import '../models/token_model.dart';
import '../models/devicetype_model.dart';

import 'package:flutter/material.dart';

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

  WhichDataIcons get icons {
    // TODO: option between outlined and filled; maybe add a third option for the fab; different icons for different devices
    switch (this) {
      case WhichData.users:
        return WhichDataIcons(
          single: Icons.person,
          multiple: Icons.group_outlined,
        );
      case WhichData.devices:
        return WhichDataIcons(
          single: Icons.devices_outlined,
          multiple: Icons.devices_outlined,
        );
      case WhichData.deviceTypes:
        return WhichDataIcons(
          single: Icons.devices_outlined,
          multiple: Icons.devices_outlined,
        );
      case WhichData.classes:
        return WhichDataIcons(
          single: Icons.class_outlined,
          multiple: Icons.class_outlined,
        );
      case WhichData.usercards:
        return WhichDataIcons(
          single: Icons.credit_card_outlined,
          multiple: Icons.credit_card_outlined,
        );
      case WhichData.tokens:
        return WhichDataIcons(
          single: Icons.token_outlined,
          multiple: Icons.token_outlined,
        );
    }
  }
}

class WhichDataIcons {
  WhichDataIcons({required this.single, required this.multiple});

  final IconData single;
  final IconData multiple;
}
