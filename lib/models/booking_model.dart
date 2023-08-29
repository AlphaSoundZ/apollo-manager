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
      id: json['id'] as int,
      begin: DateTime.parse(json['begin']),
      end: json['end'] != null ? DateTime.parse(json['end']) : null,
      user: json['user_id'] as int,
      device: json['device_id'] as int,
    );
  }
}
