import 'package:flutter/material.dart';
import 'package:stock_management_tool/components/field_sort_widget.dart';

class ExportStockProvider extends ChangeNotifier {
  bool showTable = false;
  List fields = [];
  List stock = [];

  int prevSortIndex = 0;

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

  void sortStock({required String field, required Sort sort}) {
    print("$sort, $field");
    if (sort == Sort.asc) {
      stock.sort((a, b) {
        if (a[field] == null) return 1;
        if (b[field] == null) return -1;
        return a[field].compareTo(b[field]);
      });
    } else if (sort == Sort.desc) {
      stock.sort((a, b) {
        if (a[field] == null) return 1;
        if (b[field] == null) return -1;
        return b[field].compareTo(a[field]);
      });
    }
    fields[prevSortIndex]["sort"] = Sort.none;
    prevSortIndex = fields.indexWhere((element) => element["field"] == field);
    fields[prevSortIndex]["sort"] = sort;
    notifyListeners();
  }
}
