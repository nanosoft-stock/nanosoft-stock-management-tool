import 'dart:io';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:stock_management_tool/features/visualize_stock/data/models/stock_field_model.dart';
import 'package:stock_management_tool/features/visualize_stock/data/models/stock_model.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/entities/stock_field_entity.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/repositories/visualize_stock_repository.dart';
import 'package:stock_management_tool/helper/string_casting_extension.dart';
import 'package:stock_management_tool/injection_container.dart';
import 'package:stock_management_tool/objectbox.dart';

class VisualizeStockRepositoryImplementation implements VisualizeStockRepository {
  final ObjectBox _objectBox = sl.get<ObjectBox>();

  @override
  Future<List<StockFieldModel>> getAllFields() async {
    List fields = _objectBox.getInputFields().map((e) => e.toJson()).toList();

    return fields.map((e) => StockFieldModel.fromJson(e)).toSet().toList();
  }

  @override
  Future<List<Map<String, dynamic>>> getAllStocks() async {
    List stocks = _objectBox.getStocks().map((e) => e.toJson()).toList();

    return stocks.map((e) => StockModel.fromJson(e).toJson()).toList();
  }

  @override
  Future<List<StockFieldModel>> sortFields({required String field, required Sort sort}) async {
    List fields = _objectBox.getInputFields().map((e) {
      Map json = e.toJson();
      if (json["field"] == field) {
        json["sort"] = sort;
      } else {
        json["sort"] = Sort.none;
      }
      return json;
    }).toList();

    return fields.map((e) => StockFieldModel.fromJson(e)).toSet().toList();
  }

  @override
  Future<List<Map<String, dynamic>>> sortStocks({required String field, required Sort sort}) async {
    List stocks = _objectBox.getStocks().map((e) => e.toJson()).toList();

    compareWithBlank(a, b) {
      bool isABlank = a == null || a == "";
      bool isBBlank = b == null || b == "";

      if (sort == Sort.asc) {
        if (isABlank) return 1;
        if (isBBlank) return -1;
      } else if (sort == Sort.desc) {
        if (isABlank) return -1;
        if (isBBlank) return 1;
      }

      return a.toString().toLowerCase().compareTo(b.toString().toLowerCase());
    }

    if (sort == Sort.asc) {
      stocks.sort((a, b) => compareWithBlank(a[field], b[field]));
    } else if (sort == Sort.desc) {
      stocks.sort((a, b) => compareWithBlank(b[field], a[field]));
    }

    return stocks.map((e) => StockModel.fromJson(e).toJson()).toList();
  }

  @override
  Future<void> exportToExcel() async {
    Excel excel = Excel.createExcel();

    excel.rename("Sheet1", "Stock");
    Sheet sheetObject = excel["Stock"];

    List fields = await getAllFields();
    List stock = await getAllStocks();

    int column = 0;
    int row = 0;
    while (row <= stock.length) {
      column = 0;
      if (row == 0) {
        for (var field in fields) {
          var cell =
              sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row));
          cell.value = TextCellValue(
              field.isTitleCase ? field.field.toString().toTitleCase() : field.field.toUpperCase());
          column++;
        }
      } else {
        for (var field in fields) {
          var cell =
              sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row));
          cell.value = TextCellValue(stock[row - 1][field.field].toString());
          column++;
        }
      }
      row++;
    }

    final path = await FilePicker.platform.saveFile(
        fileName: "Stock-${DateFormat("yyyy-MM-dd").format(DateTime.now())}.xlsx",
        lockParentWindow: true);

    if (path != null) {
      List<int> excelFileBytes =
          excel.save(fileName: "Stock-${DateFormat("yyyy-MM-dd").format(DateTime.now())}.xlsx")!;

      File(path)
        ..createSync(recursive: true)
        ..writeAsBytesSync(excelFileBytes);
    }
  }
}