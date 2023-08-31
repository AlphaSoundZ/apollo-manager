import 'list_tile_content_model.dart';

class Usercard {
  Usercard({required this.id, required this.uid, required this.usercardType});

  final int id;
  final String uid;
  final String usercardType;
  late ListTileContent content = ListTileContent(
    title: uid.toString(),
    leading: id.toString(),
    subTitle: usercardType.toString(),
  );

  static Usercard fromJson(Map<String, dynamic> json) {
    return Usercard(
      id: int.parse(json['id'].toString()),
      uid: json['uid'].toString(),
      usercardType: json['type']['name'].toString(),
    );
  }
}
