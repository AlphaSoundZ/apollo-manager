import '../../models/prebook_model.dart';
import '../../views/stack_views/stack_details_views/user_details_view.dart';

import '../models/class_model.dart';
import '../models/device_model.dart';
import '../models/stack_view_model.dart';
import '../models/user_model.dart';
import '../models/usercard_model.dart';
import '../models/token_model.dart';
import '../models/devicetype_model.dart';

import 'package:flutter/material.dart';

import '../views/action_views/edit_user_view.dart';

enum WhichData {
  users,
  devices,
  deviceTypes,
  classes,
  usercards,
  tokens,
  prebook,
}

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
      case WhichData.prebook:
        return Prebook.fromJson(json);
    }
  }

  String get route {
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
      case WhichData.prebook:
        return "/prebook";
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
      case WhichData.prebook:
        return WhichDataIcons(
          single: Icons.calendar_today_outlined,
          multiple: Icons.calendar_today_outlined,
        );
    }
  }

  StackViewModel detailsView(context, int itemId) {
    switch (this) {
      case WhichData.users:
        return userDetailsStackView(
          context,
          id: itemId,
          whichData: this,
        );
      default:
        return StackViewModel(
          title: "Details for id $itemId",
          subTitle: route,
          content: Center(
            child: Text(name),
          ),
        );
    }
  }

  Widget editSideSheet(context, int itemId,
      {required Function() onCancel,
      required Function() onSave,
      required Function() onDelete}) {
    switch (this) {
      default:
        return EditUserViewContent(
          key: UniqueKey(),
          id: itemId,
          onCancel: onCancel,
          onSubmit: onSave,
          onDelete: onDelete,
          // context,
          // id: itemId,
        );
    }
  }
}

class WhichDataIcons {
  WhichDataIcons({required this.single, required this.multiple});

  final IconData single;
  final IconData multiple;
}
