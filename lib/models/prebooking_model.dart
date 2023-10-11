import '../enums/which_data.dart';
import '../models/data_model.dart';
import 'package:flutter/material.dart';

import 'list_tile_content_model.dart';
import 'package:provider/provider.dart';

class Prebooking {
  Prebooking({
    required this.id,
    required this.begin,
    required this.end,
    required this.amount,
    required this.userId,
  });

  final int id;
  final DateTime begin;
  final DateTime end;
  final int amount;
  final int userId;

  BuildContext? context;

  get user => context == null
      ? null
      : Provider.of<DataModel>(context!, listen: true)
          .getById(context, WhichData.users, userId);

  ListTileContent content(BuildContext context) {
    this.context = context;

    return ListTileContent(
      // get fullName using userId and provider
      title:
          "${user == null ? 'unkown user' : user!.name.fullName} has reserved $amount devices",
      leading: userId.toString(),
      // beautiful date format
      subTitle:
          '${begin.day}.${begin.month}.${begin.year}: ${begin.hour}:${begin.minute} - ${end.hour}:${end.minute}',
    );
  }

  factory Prebooking.fromJson(BuildContext context, Map<String, dynamic> json) {
    return Prebooking(
      id: int.parse(json['id'].toString()),
      begin: DateTime.parse(json['begin']),
      end: DateTime.parse(json['end']),
      amount: int.parse(json['amount'].toString()),
      userId: int.parse(json['user_id'].toString()),
    );
  }
}
