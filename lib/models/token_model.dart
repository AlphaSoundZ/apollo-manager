import 'list_tile_content_model.dart';
import 'user_model.dart';

class Token {
  Token({
    required this.id,
    required this.username,
    required this.permissionIds,
    required this.permissionTexts,
    required this.lastChange,
    required this.user,
  });

  final int id;
  final String username;
  final List<dynamic> permissionIds;
  final List<dynamic> permissionTexts;
  final String lastChange;
  final User user;

  late ListTileContent content = ListTileContent(
    title: "$username (${user.name.fullName})",
    leading: id.toString(),
    subTitle: permissionTexts.join(", "),
  );
}