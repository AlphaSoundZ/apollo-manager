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
  const User({
    required this.id,
    required this.name,
    required this.className,
    //required this.bookings,
  });

  final int id;
  final Name name;
  final String className;
  //final List<Bookings> bookings;
}
