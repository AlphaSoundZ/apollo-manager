import 'list_tile_content_model.dart';

class Prebook {
  Prebook({
    required this.id,
    required this.begin,
    required this.end,
    required this.userId,
  });

  final int id;
  final DateTime begin;
  final DateTime end;
  final int userId;

  late ListTileContent content = ListTileContent(
    title: 'Prebook id: $id',
    leading: userId.toString(),
    // beautiful date format
    subTitle:
        '${begin.day}.${begin.month}.${begin.year}: ${begin.hour}:${begin.minute} - ${end.hour}:${end.minute}',
  );

  factory Prebook.fromJson(Map<String, dynamic> json) {
    return Prebook(
      id: json['id'],
      begin: DateTime.parse(json['begin']),
      end: DateTime.parse(json['end']),
      userId: json['user_id'],
    );
  }
}
