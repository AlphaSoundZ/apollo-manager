import 'package:flutter/material.dart';
import '../enums/which_data.dart';
import '../classes/api.dart';

class DataModel extends ChangeNotifier {
  Map<WhichData, dynamic> data = <WhichData, dynamic>{};

  DataModel() {
    // iterate through all data types and add them to the data list
    for (WhichData type in WhichData.values) {
      data[type] = [];
    }
  }

  List<dynamic> get(WhichData whichData) {
    List<dynamic> object = data[whichData];

    debugPrint("Get data for $whichData");

    if (object.isEmpty) {
      updateData(dataType: whichData);
      return [];
    }

    // notifyListeners();
    object = data[whichData];

    return object;
  }

  Future<void> updateData({
    required WhichData dataType,
    bool draw = true,
  }) async {
    debugPrint("Updating data for $dataType");
    data[dataType] = await Api().fetchData(dataType);

    if (draw) {
      debugPrint("Notifying listeners");
      notifyListeners();
    }
  }

  void updateAll() async {
    await updateData(dataType: WhichData.users, draw: false);

    debugPrint("Notifying listeners");
    notifyListeners();
  }
}
