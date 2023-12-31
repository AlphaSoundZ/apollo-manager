import 'package:flutter/material.dart';

import 'list_tile_content_model.dart';
import 'user_model.dart';

class Token {
  Token({
    required this.id,
    required this.username,
    required this.permissions,
    required this.permissionTexts,
    required this.lastChange,
    required this.user,
  });

  final int id;
  final String username;
  final List<dynamic> permissions;
  final List<dynamic> permissionTexts;
  final String lastChange;
  final User user;

  ListTileContent content(BuildContext context) {
    return ListTileContent(
      title: "$username (${user.name.fullName})",
      leading: id.toString(),
      subTitle: permissionTexts.join(", "),
    );
  }

  static Token fromJson(Map<String, dynamic> json) {
    return Token(
      id: int.parse(json['token_id'].toString()),
      username: json['username'].toString(),
      permissions: json['permission_id'] as List<dynamic>,
      permissionTexts: json['permission_text'] as List<dynamic>,
      lastChange: json['last_change'].toString(),
      user: User.fromJson(json['user']),
    );
  }
}
