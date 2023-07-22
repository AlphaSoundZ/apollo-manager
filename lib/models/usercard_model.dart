import 'list_tile_content_model.dart';

class Usercard {
  Usercard({required this.id, required this.uid, required this.usercardType});

  final int id;
  final String uid;
  final String usercardType;
  late ListTileContent content = ListTileContent(
    title: uid,
    leading: id.toString(),
    subTitle: usercardType,
  );
}
