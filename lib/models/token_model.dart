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

  static Token fromJson(Map<String, dynamic> json) {
    return Token(
      id: json['token_id'] as int,
      username: json['username'].toString(),
      permissionIds: json['permission_id'] as List<dynamic>,
      permissionTexts: json['permission_text'] as List<dynamic>,
      lastChange: json['last_change'].toString(),
      user: User.fromJson(json['user']),
    );
  }
}
