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
}
