import 'package:apollo_manager/models/get_response_model.dart';
import 'package:flutter/material.dart';
import '../enums/which_data.dart';
import '../services/api.dart';

class DataModel extends ChangeNotifier {
  Map<WhichData, GetResponseBody> data = WhichData.values
      .asMap()
      .map((key, value) => MapEntry(value, GetResponseBody.empty()));
  Map<WhichData, GetResponseBody> searchResults = WhichData.values
      .asMap()
      .map((key, value) => MapEntry(value, GetResponseBody.empty()));
  Map<WhichData, bool> isLoaded =
      WhichData.values.asMap().map((key, value) => MapEntry(value, false));

  DataModel() {
    // iterate through all data types and add them to the data list
    for (WhichData type in WhichData.values) {
      data[type] = GetResponseBody.empty();
      isLoaded[type] = false;
    }
  }

  GetResponseBody get(WhichData whichData) {
    GetResponseBody object = data[whichData]!;

    if (object.isEmpty()) {
      if (isLoaded[whichData] == false) {
        updateData(whichData: whichData);
        isLoaded[whichData] = true;
      }
    }

    return object;
  }

  dynamic getById(WhichData whichData, int id) {
    GetResponseBody object = data[whichData]!;

    if (object.isEmpty()) {
      updateData(whichData: whichData);
      return [];
    }

    return object.data
        .firstWhere((element) => element.id == id, orElse: () => null);
  }

  Future<void> updateData({
    required WhichData whichData,
    Map<String, dynamic>? params,
    bool draw = true,
  }) async {
    data[whichData] = await Api().get(
      route: whichData.route,
      whichData: whichData,
      params: params,
    );

    // if there is a search result for this data type, update it
    if (!searchResults[whichData]!.isEmpty()) {
      searchResults[whichData] = await Api().get(
        route: whichData.route,
        whichData: whichData,
        params: searchResults[whichData]!.params,
      );
    }

    if (draw) {
      notifyListeners();
    }
  }

  Future<void> updateAll() async {
    final List<Future<void>> futures = [];
    
    for (WhichData type in WhichData.values) {
      futures.add(updateData(whichData: type, draw: false));
    }

    await Future.wait(futures);

    notifyListeners();
  }

  GetResponseBody search({
    required WhichData whichData,
    required Map<String, dynamic> params,
    bool draw = true,
  }) {
    if (searchResults[whichData]!.isEmpty()) {
      Api()
          .get(
        route: whichData.route,
        whichData: whichData,
        params: params,
      )
          .then(
        (response) {
          searchResults[whichData] = response;
          if (draw) {
            notifyListeners();
          }
        },
      );
    }

    return searchResults[whichData]!;
  }

  void clearSearch({bool draw = false}) {
    searchResults
        .clear(); // TODO: Maybe only clear the search results of specific data types? (only clear the search results of the current page), needs to be tested

    searchResults = WhichData.values
        .asMap()
        .map((key, value) => MapEntry(value, GetResponseBody.empty()));

    if (draw) {
      notifyListeners();
    }
  }
}
