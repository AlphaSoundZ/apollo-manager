import 'package:flutter/material.dart';
import '../enums/which_data.dart';
import '../classes/api.dart';

class DataModel extends ChangeNotifier {
  Map<WhichData, dynamic> data = <WhichData, dynamic>{};
  List<dynamic> searchResults = [];

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

  bool _searchRunning = false;

  List<dynamic> search({
    required WhichData whichData,
    required Map<String, dynamic> params,
    bool draw = true,
  }) {
    if (!_searchRunning) {
      searchResults.clear();
    }

    if (!_searchRunning) {
      searchResults.clear();

      Api()
          .fetchData(
        whichData: whichData,
        params: params,
      )
          .then(
        (value) {
          searchResults = value;
          _searchRunning = true;
          if (draw) {
            notifyListeners();
          }
        },
      );

      return [];
    } else {
      _searchRunning = false;
      return searchResults;
    }
  }

  void clearSearch({bool draw = true}) {
    searchResults.clear();

    if (draw) {
      notifyListeners();
    }
  }
}
