import '../models/class_model.dart';
import '../models/device_model.dart';
import '../models/user_model.dart';
import '../models/usercard_model.dart';

enum WhichData { users, devices, classes, usercards }

extension WhichDataExtionsion on WhichData {
  dynamic get model {
    switch (this) {
      case WhichData.users:
        return User;
      case WhichData.devices:
        return Device;
      case WhichData.classes:
        return ClassModel;
      case WhichData.usercards:
        return Usercard;
    }
  }
}
