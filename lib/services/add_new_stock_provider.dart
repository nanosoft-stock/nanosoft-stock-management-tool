import 'package:flutter/material.dart';

class AddNewStockProvider extends ChangeNotifier {
  Map lockableData = {};

  void changeLockableData({
    required String field,
    required Map data,
  }) async {
    lockableData[field] = data;
    notifyListeners();
  }

  void changeLockableDataSubField({
    required String field,
    required String subField,
    required dynamic value,
  }) async {
    lockableData[field][subField] = value;
    print("provider: ${lockableData["make"]["locked"]}");
    notifyListeners();
  }

  void deleteLockableData() async {
    lockableData = {};
    notifyListeners();
  }
}
