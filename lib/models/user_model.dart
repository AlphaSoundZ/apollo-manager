import 'list_tile_content_model.dart';
import 'class_model.dart';

class Name {
  const Name({
    required this.firstname,
    required this.lastname,
  });

  final String firstname;
  final String lastname;
  String get fullName => '$firstname $lastname';
  String get shortName => '${firstname[0]}. $lastname';
}

class User {
  User({
    required this.id,
    required this.name,
    required this.class_,
    required this.multiBooking,
    //required this.bookings,
  });

  final int id;
  final Name name;
  final bool multiBooking;
  late ClassModel class_;
  late ListTileContent content = ListTileContent(
    title: name.fullName,
    leading: id.toString(),
    subTitle: class_.name,
  );
  //final List<Bookings> bookings;

  static User fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: Name(
        firstname: json['firstname'].toString(),
        lastname: json['lastname'].toString(),
      ),
      multiBooking: json['multi_booking'] == 1 ? true : false,
      class_: ClassModel.fromJson(json['class']),
      //bookings: json['bookings'] as List<Bookings>,
    );
  }
}
