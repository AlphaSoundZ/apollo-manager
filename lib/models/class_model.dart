import 'list_tile_content_model.dart';

class ClassModel {
  ClassModel({
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

  static ClassModel fromJson(Map<String, dynamic> json) {
    return ClassModel(
      id: json['id'] as int,
      name: json['name'].toString(),
      amount: json['amount'] as int,
    );
  }
}
