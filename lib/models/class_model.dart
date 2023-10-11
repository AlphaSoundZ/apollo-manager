import 'list_tile_content_model.dart';
import 'package:flutter/material.dart';

class ClassModel {
  ClassModel({
    required this.id,
    required this.name,
    this.amount = -1,
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

  static ClassModel fromJson(Map<String, dynamic> json) {
    return ClassModel(
      id: int.parse(json['id'].toString()),
      name: json['name'].toString(),
      amount: int.parse((json['amount'] ?? -1).toString()),
    );
  }
}
