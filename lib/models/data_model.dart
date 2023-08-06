import 'package:flutter/material.dart';
import '../enums/which_data.dart';
import '../services/api.dart';

class DataModel extends ChangeNotifier {
  Map<WhichData, dynamic> data = <WhichData, dynamic>{};
  List<dynamic> searchResults = [];
  Map<WhichData, bool> isLoaded = {};

  DataModel() {
    // iterate through all data types and add them to the data list
    for (WhichData type in WhichData.values) {
      data[type] = [];
      isLoaded[type] = false;
    }
  }

  List<dynamic> get(WhichData whichData) {
    List<dynamic> object = data[whichData];

    if (object.isEmpty) {
      if (isLoaded[whichData] == false) {
        updateData(dataType: whichData);
        isLoaded[whichData] = true;
      }
      return [];
    }

    // notifyListeners();
    object = data[whichData];

    return object;
  }

  dynamic getById(WhichData whichData, int id) {
    List<dynamic> object = data[whichData];

    if (object.isEmpty) {
      updateData(dataType: whichData);
      return [];
    }

    return object.firstWhere((element) => element.id == id, orElse: () => []);
  }

  Future<void> updateData({
    required WhichData dataType,
    Map<String, dynamic>? params,
    bool draw = true,
  }) async {
    data[dataType] = await Api().fetchData(whichData: dataType, params: params);

    if (draw) {
      notifyListeners();
    }
  }

  void updateAll() async {
    await updateData(dataType: WhichData.users, draw: false);

    // TODO: update search results

    notifyListeners();
  }

  List<dynamic> search({
    required WhichData whichData,
    required Map<String, dynamic> params,
    bool draw = true,
  }) {
    if (searchResults.isEmpty) {
      Api()
          .fetchData(
        whichData: whichData,
        params: params,
      )
          .then(
        (value) {
          searchResults = value;
          if (draw) {
            notifyListeners();
          }
        },
      );
    }

    return searchResults;
  }

  void clearSearch({bool draw = false}) {
    searchResults.clear();

    if (draw) {
      notifyListeners();
    }
  }
}
