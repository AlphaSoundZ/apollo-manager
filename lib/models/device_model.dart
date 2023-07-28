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
  late ListTileContent content = ListTileContent(
    title: uid,
    leading: id.toString(),
    subTitle: deviceType,
  );

  static Device fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id'] as int,
      uid: json['uid'].toString(),
      deviceType: json['type']['name'].toString(),
    );
  }
}
