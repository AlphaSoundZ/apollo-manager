import '../models/get_response_model.dart';
import 'package:flutter/material.dart';
import '../enums/which_data.dart';
import '../services/api.dart';

class DataModel extends ChangeNotifier {
  // TODO: only add WhichData types where user has the permission to view the data to save requests amount
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

  GetResponseBody get(context, WhichData whichData) {
    GetResponseBody object = data[whichData]!;

    if (object.isEmpty()) {
      if (isLoaded[whichData] == false) {
        updateData(context, whichData: whichData);
        isLoaded[whichData] = true;
      }
    }

    return object;
  }

  void deleteDataModel() {
    data = WhichData.values
        .asMap()
        .map((key, value) => MapEntry(value, GetResponseBody.empty()));
    searchResults = WhichData.values
        .asMap()
        .map((key, value) => MapEntry(value, GetResponseBody.empty()));
    isLoaded =
        WhichData.values.asMap().map((key, value) => MapEntry(value, false));
  }

  dynamic getById(context, WhichData whichData, int id) {
    GetResponseBody object = data[whichData]!;

    if (object.isEmpty()) {
      updateData(context, whichData: whichData);
      return null;
    }

    return object.data
        .firstWhere((element) => element.id == id, orElse: () => null);
  }

  Future<void> updateData(
    BuildContext context, {
    required WhichData whichData,
    Map<String, dynamic>? params,
    bool draw = true,
  }) async {
    data[whichData] = await Api().get(
      context,
      route: whichData.endpoint,
      whichData: whichData,
      params: params,
    );

    // if there is a search result for this data type, update it
    if (!searchResults[whichData]!.isEmpty()) {
      // ignore: use_build_context_synchronously
      searchResults[whichData] = await Api().get(
        context,
        route: whichData.endpoint,
        whichData: whichData,
        params: searchResults[whichData]!.params,
      );
    }

    if (draw) {
      notifyListeners();
    }
  }

  Future<void> updateAll(BuildContext context) async {
    final List<Future<void>> futures = [];

    for (WhichData type in data.keys) {
      futures.add(updateData(context, whichData: type, draw: false));
    }

    await Future.wait(futures);

    notifyListeners();
  }

  GetResponseBody search(
    BuildContext context, {
    required WhichData whichData,
    required Map<String, dynamic> params,
    bool draw = true,
  }) {
    if (searchResults[whichData]!.isEmpty()) {
      Api()
          .get(
        context,
        route: whichData.endpoint,
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
    // TODO: Maybe only clear the search results of specific data types? (only clear the search results of the current page), needs to be tested

    searchResults = searchResults.map(
      (key, value) => MapEntry(key, GetResponseBody.empty()),
    );

    if (draw) {
      notifyListeners();
    }
  }
}
