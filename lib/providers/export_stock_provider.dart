import 'package:flutter/material.dart';

class ExportStockProvider extends ChangeNotifier {
  bool showTable = false;
  List fields = [];
  List stock = [];

  void setShowTable({required bool showTable}) {
    this.showTable = showTable;
  }

  void setFields({required List fields}) {
    this.fields = fields;
    notifyListeners();
  }

  void setStock({required List stock}) {
    this.stock = stock;
    notifyListeners();
  }
}
