import 'list_tile_content_model.dart';

class Bookings {
  const Bookings({
    required this.id,
    required this.begin,
    required this.end,
    required this.amount,
  });

  final int id;
  final DateTime begin;
  final DateTime end;
  final int amount;
}

class Name {
  const Name({
    required this.firstname,
    required this.lastname,
  });

  final String firstname;
  final String lastname;
  String get fullName => '$firstname $lastname';
}

class User {
  User({
    required this.id,
    required this.name,
    required this.className,
    //required this.bookings,
  });

  final int id;
  final Name name;
  final String className;
  late ListTileContent content = ListTileContent(
    title: name.fullName,
    leading: id.toString(),
    subTitle: className,
  );
  //final List<Bookings> bookings;

  static User fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: Name(
        firstname: json['firstname'].toString(),
        lastname: json['lastname'].toString(),
      ),
      className: json['class']['name'].toString(),
      //bookings: json['bookings'] as List<Bookings>,
    );
  }
}
