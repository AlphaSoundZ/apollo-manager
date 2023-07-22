import '../models/class_model.dart';
import '../models/device_model.dart';
import '../models/user_model.dart';

enum WhichData { users, devices, classes }

extension WhichDataExtionsion on WhichData {
  dynamic get model {
    switch (this) {
      case WhichData.users:
        return User;
      case WhichData.devices:
        return Device;
      case WhichData.classes:
        return ClassModel;
    }
  }
}
