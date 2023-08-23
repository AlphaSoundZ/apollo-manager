enum Permissions {
  book,
  addCsv,
  user,
  usercard,
  device,
  userClass,
  deviceType,
  usercardType,
  token,
  event,
  prebook,
}

extension PermissionsExtension on Permissions {
  int get value {
    return index + 1;
  }
}