import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'package:stock_management_tool/helper/string_casting_extension.dart';
import 'package:stock_management_tool/models/all_predefined_data.dart';
import 'package:stock_management_tool/services/firestore_rest_api.dart';

class ExportStockHelper {
  Future<List> fetchData() async {
    List stock = [];

    stock = (await FirestoreRestApi().getDocuments(path: "stock_data", includeDocRef: true)).data;

    stock = stock
        .map((element) => element
            .map((field, value) => MapEntry(field, value.values.first))
            .cast<String, dynamic>())
        .toList();

    return stock;
  }

  Future<void> convertToExcel({
    required List stock,
  }) async {
    Excel excel = Excel.createExcel();

    excel.rename("Sheet1", "Stock");
    Sheet sheetObject = excel["Stock"];

    Set fields = {};

    for (String category in AllPredefinedData.data["categories"]) {
      fields.addAll(AllPredefinedData.data[category]["fields"].map((e) => e["field"]));
    }

    List columnNames = fields.toList();

    int column = 0;
    int row = 0;
    while (row <= stock.length) {
      column = 0;
      if (row == 0) {
        for (var name in columnNames) {
          var cell =
              sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row));
          cell.value = TextCellValue(name.toString().toTitleCase());
          column++;
        }
      } else {
        for (var field in AllPredefinedData.data["laptops"]["fields"]) {
          var cell =
              sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row));
          cell.value = TextCellValue(stock[row - 1][field["field"]].toString());
          column++;
        }
      }
      row++;
    }

    excel.save(fileName: "Stock-${DateFormat("yyyy-mm-dd").format(DateTime.now())}.xlsx");
  }
}
