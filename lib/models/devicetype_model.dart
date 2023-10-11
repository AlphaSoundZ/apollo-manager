import 'package:flutter/material.dart';

import 'list_tile_content_model.dart';

class DeviceType {
  DeviceType({
    required this.id,
    required this.name,
    required this.amount,
  });

  final int id;
  final String name;
  final int amount;
  ListTileContent content(BuildContext context) {
    return ListTileContent(
      title: name,
      leading: id.toString(),
      subTitle: "Amount: $amount",
    );
  }

  static DeviceType fromJson(Map<String, dynamic> json) {
    return DeviceType(
      id: int.parse(json['id'].toString()),
      name: json['name'].toString(),
      amount: int.parse(json['amount'].toString()),
    );
  }
}
