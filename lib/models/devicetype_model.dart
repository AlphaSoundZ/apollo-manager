import 'list_tile_content_model.dart';

class DeviceType {
  DeviceType({
    required this.id,
    required this.name,
    required this.amount,
  });

  final int id;
  final String name;
  final int amount;
  late ListTileContent content = ListTileContent(
    title: name,
    leading: id.toString(),
    subTitle: "Amount: $amount",
  );

  static DeviceType fromJson(Map<String, dynamic> json) {
    return DeviceType(
      id: json['id'] as int,
      name: json['name'].toString(),
      amount: json['amount'] as int,
    );
  }
}
