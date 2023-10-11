import 'package:flutter/cupertino.dart';

import 'list_tile_content_model.dart';

class Device {
  Device({
    required this.id,
    required this.uid,
    required this.deviceType,
  });

  final int id;
  final String uid;
  final String deviceType;
  ListTileContent content(BuildContext context) {
    return ListTileContent(
      title: uid,
      leading: id.toString(),
      subTitle: deviceType,
    );
  }

  static Device fromJson(Map<String, dynamic> json) {
    return Device(
      id: int.parse(json['id'].toString()),
      uid: json['uid'].toString(),
      deviceType: json['type']['name'].toString(),
    );
  }
}
