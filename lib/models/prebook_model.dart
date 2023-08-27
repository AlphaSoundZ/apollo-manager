import 'package:apollo_manager/enums/which_data.dart';
import 'package:apollo_manager/models/data_model.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'list_tile_content_model.dart';
import 'package:provider/provider.dart';

class Prebook {
  Prebook(
    this.context, {
    required this.id,
    required this.begin,
    required this.end,
    required this.userId,
  });

  final BuildContext context;
  final int id;
  final DateTime begin;
  final DateTime end;
  final int userId;

  late ListTileContent content = ListTileContent(
    // get fullName using userId and provider
    title: Provider.of<DataModel>(context, listen: false)
        .getById(context, WhichData.users, id)
        .name
        .fullName,

    leading: userId.toString(),
    // beautiful date format
    subTitle:
        '${begin.day}.${begin.month}.${begin.year}: ${begin.hour}:${begin.minute} - ${end.hour}:${end.minute}',
  );

  factory Prebook.fromJson(BuildContext context, Map<String, dynamic> json) {
    return Prebook(
      context,
      id: json['id'],
      begin: DateTime.parse(json['begin']),
      end: DateTime.parse(json['end']),
      userId: json['user_id'],
    );
  }
}
