import 'dart:async';
import 'dart:io';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:stock_management_tool/constants/constants.dart';
import 'package:stock_management_tool/constants/enums.dart';
import 'package:stock_management_tool/features/visualize_stock/data/models/stock_field_model.dart';
import 'package:stock_management_tool/features/visualize_stock/data/models/stock_model.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/repositories/visualize_stock_repository.dart';
import 'package:stock_management_tool/helper/add_new_item_location_history_helper.dart';
import 'package:stock_management_tool/helper/add_new_stock_helper.dart';
import 'package:stock_management_tool/helper/string_casting_extension.dart';
import 'package:stock_management_tool/injection_container.dart';
import 'package:stock_management_tool/objectbox.dart';
import 'package:stock_management_tool/services/firestore.dart';

class VisualizeStockRepositoryImplementation
    implements VisualizeStockRepository {
  final ObjectBox _objectBox = sl.get<ObjectBox>();

  @override
  void listenToCloudDataChange({required Function() onChange}) async {
    _objectBox.getStockStream().listen((event) {
      onChange();
    });
    _objectBox.getInputFieldStream().listen((event) {
      onChange();
    });
  }

  @override
  List<StockFieldModel> getAllFields() {
    List fields = _objectBox.getInputFields().map((e) => e.toJson()).toList();

    return fields.map((e) => StockFieldModel.fromJson(e)).toSet().toList();
  }

  @override
  List<Map<String, dynamic>> getAllStocks() {
    List stocks = _objectBox.getStocks().map((e) => e.toJson()).toList();

    stocks.sort((a, b) => a["date"].compareTo(b["date"]));

    return stocks.map((e) => StockModel.fromJson(e).toJson()).toList();
  }

  @override
  List<StockFieldModel> sortFields(
      {required String field, required Sort sort}) {
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
  List<Map<String, dynamic>> sortStocks(
      {required String field, required Sort sort, required List stocks}) {
    print("in sort stocks");

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
  Future<void> importFromExcel() async {
    var filePathResult = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
      allowMultiple: false,
    );

    String? filePath;

    if (filePathResult != null && filePathResult.files.isNotEmpty) {
      filePath = filePathResult.files.first.path;
    } else {
      return;
    }

    var bytes = File(filePath!).readAsBytesSync();
    Excel excel = Excel.decodeBytes(bytes);

    List allLocations = await _fetchAllLocations();

    Map warehouseLocations = allLocations
        .firstWhere((element) => element.keys.contains("warehouse_locations"));
    Map containers = allLocations
        .firstWhere((element) => element.keys.contains("containers"));
    Map items =
        allLocations.firstWhere((element) => element.keys.contains("items"));

    List header = [];

    for (var table in excel.tables.keys) {
      for (var cell in excel.tables[table]!.rows.first) {
        header.add((cell!.value! as TextCellValue).value.toLowerCase());
      }

      for (var row in excel.tables[table]!.rows.sublist(1)) {
        Map<String, dynamic> rowData = {};

        for (int i = 0; i < row.length; i++) {
          final cellValue = row[i]!.value;

          Object? value;

          switch (cellValue) {
            case null:
              value = null;
              break;
            case TextCellValue():
              value = cellValue.value;
              break;
            case IntCellValue():
              value = cellValue.value.toString();
              break;
            case BoolCellValue():
              value = cellValue.value;
              break;
            case DoubleCellValue():
              value = cellValue.value;
              break;
            case DateCellValue():
              // print('  date: ${cellValue.year} ${cellValue.month} ${cellValue.day} (${cellValue.asDateTimeLocal()})');
              break;
            case TimeCellValue():
              // print('  time: ${cellValue.hour} ${cellValue.minute} ... (${cellValue.asDuration()})');
              break;
            case DateTimeCellValue():
              // print('  date with time: ${cellValue.year} ${cellValue.month} ${cellValue.day} ${cellValue.hour} ... (${cellValue.asDateTimeLocal()})');
              break;
            default:
              break;
          }

          rowData[header[i]] = value;
        }

        await sl.get<Firestore>().createDocument(
              path: "stock_data",
              data: AddNewStockHelper.toJson(data: rowData),
            );

        await _addNewLocations(
          locations: warehouseLocations["warehouse_locations"],
          newValue: rowData["warehouse location"],
          uid: warehouseLocations["uid"],
          updateField: "warehouse_locations",
        );

        await _addNewLocations(
          locations: containers["containers"],
          newValue: rowData["container id"],
          uid: containers["uid"],
          updateField: "containers",
        );

        await _addNewLocations(
          locations: items["items"],
          newValue: rowData["item id"],
          uid: items["uid"],
          updateField: "items",
        );

        await _addItemLocationHistory(data: rowData);
      }
    }
  }

  Future<List> _fetchAllLocations() async {
    List allLocations = await sl
        .get<Firestore>()
        .getDocuments(path: "all_locations", includeUid: true);

    if (kIsLinux) {
      allLocations = allLocations.map((element) {
        Map map = {};

        for (var key in element.keys) {
          if (key == "uid") {
            map["uid"] = element["uid"]["stringValue"];
          } else {
            map[key] = element[key]["arrayValue"]["values"]
                .map((ele) => ele["stringValue"])
                .toList();
          }
        }

        return map;
      }).toList();
    }

    return allLocations;
  }

  Future<void> _addNewLocations({
    required List locations,
    required String? newValue,
    required String uid,
    required String updateField,
  }) async {
    if (newValue != null &&
        newValue.toString().trim() != "" &&
        !locations.contains(newValue.toString().trim())) {
      locations.add(newValue.toString().trim().toUpperCase());

      locations = locations.toSet().toList();

      locations.sort((a, b) => a.toString().compareTo(b.toString()));

      await sl.get<Firestore>().modifyDocument(
            path: "all_locations",
            uid: uid,
            updateMask: [updateField],
            data: !kIsLinux
                ? {
                    updateField: locations,
                  }
                : {
                    updateField: {
                      "arrayValue": {
                        "values":
                            locations.map((e) => {"stringValue": e}).toList(),
                      }
                    }
                  },
          );
    }
  }

  Future<void> _addItemLocationHistory({required Map data}) async {
    Map map = {
      "items": [data["item id"]],
      "container_id": data["container id"],
      "warehouse_location_id": data["warehouse location"],
      "move_type": "initial",
      "state": "completed",
    };

    await sl.get<Firestore>().createDocument(
          path: "stock_location_history",
          data: AddNewItemLocationHistoryHelper.toJson(data: map),
        );
  }

  @override
  Future<void> exportToExcel() async {
    Excel excel = Excel.createExcel();

    excel.rename("Sheet1", "Stock");
    Sheet sheetObject = excel["Stock"];

    List fields = getAllFields();
    List stock = getAllStocks();

    int column = 0;
    int row = 0;
    while (row <= stock.length) {
      column = 0;
      if (row == 0) {
        for (var field in fields) {
          var cell = sheetObject.cell(
              CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row));
          cell.value = TextCellValue(field.isTitleCase
              ? field.field.toString().toTitleCase()
              : field.field.toUpperCase());
          column++;
        }
      } else {
        for (var field in fields) {
          var cell = sheetObject.cell(
              CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row));
          cell.value = TextCellValue(stock[row - 1][field.field].toString());
          column++;
        }
      }
      row++;
    }

    final path = await FilePicker.platform.saveFile(
        fileName:
            "Stock-${DateFormat("yyyy-MM-dd").format(DateTime.now())}.xlsx",
        lockParentWindow: true);

    if (path != null) {
      List<int> excelFileBytes = excel.save(
          fileName:
              "Stock-${DateFormat("yyyy-MM-dd").format(DateTime.now())}.xlsx")!;

      File(path)
        ..createSync(recursive: true)
        ..writeAsBytesSync(excelFileBytes);
    }
  }
}
