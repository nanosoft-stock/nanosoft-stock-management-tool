import 'package:flutter/material.dart';

class AddNewStockProvider extends ChangeNotifier {
  String? currentCategory;
  Map cacheData = {};
  bool hasBuilt = false;

  void changeCurrentCategory({
    required String category,
  }) {
    currentCategory = category;
    notifyListeners();
  }

  void changeCacheData({
    required String field,
    required Map data,
  }) async {
    cacheData[field] = data;
  }

  void changeCacheDataSubField({
    required String field,
    required String subField,
    required dynamic value,
  }) async {
    cacheData[field][subField] = value;
    notifyListeners();
  }

  void deleteCacheData() {
    hasBuilt = false;
    currentCategory = "";
    cacheData = {};
    notifyListeners();
  }

  void refresh() {
    notifyListeners();
  }
}
