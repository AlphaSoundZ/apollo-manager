import 'list_tile_content_model.dart';

class Booking {
  Booking({
    required this.id,
    required this.begin,
    this.end,
    required this.user,
    required this.device,
  });

  final int id;
  final DateTime begin;
  final DateTime? end;
  final int user;
  final int device;

  late ListTileContent content = ListTileContent(
    title: 'Booking #$id',
    leading: id.toString(),
    subTitle: '$begin - ${end ?? 'now'}',
  );

  static Booking fromJson(Map<String, dynamic> json) {
    return Booking(
      id: int.parse(json['id'].toString()),
      begin: DateTime.parse(json['begin']),
      end: json['end'] != null ? DateTime.parse(json['end']) : null,
      user: int.parse(json['user_id'].toString()),
      device: int.parse(json['device_id'].toString()),
    );
  }
}
