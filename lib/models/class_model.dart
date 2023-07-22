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
}
