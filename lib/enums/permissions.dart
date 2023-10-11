// order needs to be the same as in the database and the id too (so the first element is id 1, second id 2 and so on)

enum Permissions {
  book,
  addCsv,
  crudUser,
  crudUsercard,
  crudDevice,
  crudUserClass,
  crudDeviceType,
  crudUsercardType,
  crudToken,
  event,
  crudPrebook,
  prebook,
}

extension PermissionsExtension on Permissions {
  int get value {
    return index + 1;
  }

  String get name {
    return toString().split('.').last;
  }
}
