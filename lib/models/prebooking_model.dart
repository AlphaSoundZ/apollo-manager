import 'package:apollo_manager/enums/which_data.dart';
import 'package:apollo_manager/models/data_model.dart';
import 'package:flutter/material.dart';

import 'list_tile_content_model.dart';
import 'package:provider/provider.dart';

import 'user_model.dart';

class Prebooking {
  Prebooking(
    this.context, {
    required this.id,
    required this.begin,
    required this.end,
    required this.amount,
    required this.userId,
  });

  final BuildContext context;
  final int id;
  final DateTime begin;
  final DateTime end;
  final int amount;
  final int userId;

  User? get user => Provider.of<DataModel>(context, listen: true)
      .getById(context, WhichData.users, userId);

  ListTileContent get content => ListTileContent(
        // get fullName using userId and provider
        title:
            "${user == null ? 'unkown user' : user!.name.fullName} has reserved $amount devices",
        leading: userId.toString(),
        // beautiful date format
        subTitle:
            '${begin.day}.${begin.month}.${begin.year}: ${begin.hour}:${begin.minute} - ${end.hour}:${end.minute}',
      );

  factory Prebooking.fromJson(BuildContext context, Map<String, dynamic> json) {
    return Prebooking(
      context,
      id: json['id'],
      begin: DateTime.parse(json['begin']),
      end: DateTime.parse(json['end']),
      amount: json['amount'],
      userId: json['user_id'],
    );
  }
}
