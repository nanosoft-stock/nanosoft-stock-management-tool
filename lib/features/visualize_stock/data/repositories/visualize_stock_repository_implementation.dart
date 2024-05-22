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

  List<String> stringFilterBy = [
    "Equals",
    "Not Equals",
    "Begins With",
    "Not Begins With",
    "Contains",
    "Not Contains",
    "Ends With",
    "Not Ends With",
  ];

  List<String> doubleFilterBy = [
    "Equals",
    "Not Equals",
    "Greater Than",
    "Lesser Than",
    "Between"
  ];

  @override
  void listenToCloudDataChange(
      {required Map visualizeStock, required Function(Map) onChange}) async {
    _objectBox.getStockStream().listen((event) {
      visualizeStock["stocks"] =
          getFilteredStocks(filters: visualizeStock["filters"]);
      onChange(visualizeStock);
    });
    // _objectBox.getInputFieldStream().listen((event) {
    //   onChange();
    // });
  }

  @override
  List<StockFieldModel> getAllFields() {
    List fields = _objectBox.getInputFields().map((e) => e.toJson()).toList();

    return fields.map((e) => StockFieldModel.fromJson(e)).toSet().toList();
  }

  @override
  List<Map<String, dynamic>> getAllStocks() {
    List stocks = _objectBox.getStocks().map((e) => e.toJson()).toList();

    stocks.sort((a, b) => b["date"].compareTo(a["date"]));

    return stocks.map((e) => StockModel.fromJson(e).toJson()).toList();
  }

  @override
  List<Map<String, dynamic>> sortStocks(
      {required String field, required Sort sort, required List stocks}) {
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
  List<Map<String, dynamic>> getInitialFilters(
      {required List fields, required List stocks}) {
    return fields.map((ele) {
      Map<String, dynamic> data = {};

      data["field"] = ele.field;
      data["show_column"] = true;
      data["sort"] = ele.field != "date" ? Sort.none : Sort.desc;
      data["filter_by"] = "";
      data["filter_value"] = "";
      data["search_value"] = "";

      data.addAll(getFilterByValuesByDatatype(
          values: stocks
              .map((stock) => stock[ele.field].toString())
              .toList()
              .cast<String>()));

      return data;
    }).toList();
  }

  @override
  Map<String, dynamic> getFilterByValuesByDatatype({required List values}) {
    Map<String, dynamic> data = {};

    if (values.every((element) {
      if (element == "") return true;
      return double.tryParse(element) is! double;
    })) {
      data = {"datatype": "string", "all_filter_by_values": stringFilterBy};
    } else {
      data = {"datatype": "double", "all_filter_by_values": doubleFilterBy};
    }

    return data;

    // for (var element in values) {
    //   if (element != "" && double.tryParse(element) is! double) {
    //     return {"datatype": "string", "all_filter_by_values": stringFilterBy};
    //   }
    // }
    //
    // return {"datatype": "double", "all_filter_by_values": doubleFilterBy};
  }

  @override
  List<Map<String, dynamic>> getFilteredStocks({required List filters}) {
    List stocks = _objectBox.getStocks().map((e) => e.toJson()).toList();

    for (var filter in filters) {
      stocks = stocks.where((element) {
        if (filter["datatype"] == "string") {
          String stockValue = element[filter["field"]].toString().toLowerCase();
          String filterValue = filter["filter_value"].toString().toLowerCase();

          if (filter["filter_by"] == "Equals") {
            return stockValue == filterValue;
          } else if (filter["filter_by"] == "Not Equals") {
            return stockValue != filterValue;
          } else if (filter["filter_by"] == "Begins With") {
            return stockValue.startsWith(filterValue);
          } else if (filter["filter_by"] == "Not Begins With") {
            return !stockValue.startsWith(filterValue);
          } else if (filter["filter_by"] == "Contains") {
            return stockValue.contains(filterValue);
          } else if (filter["filter_by"] == "Not Contains") {
            return !stockValue.contains(filterValue);
          } else if (filter["filter_by"] == "Ends With") {
            return stockValue.endsWith(filterValue);
          } else if (filter["filter_by"] == "Not Ends With") {
            return !stockValue.endsWith(filterValue);
          } else {
            return true;
          }
        } else if (filter["datatype"] == "double") {
          double? stockValue = double.tryParse(element[filter["field"]] ?? "");
          double? filterValue = double.tryParse(filter["filter_value"]);

          if (stockValue != null && filterValue != null) {
            if (filter["filter_by"] == "Equals") {
              return stockValue == filterValue;
            } else if (filter["filter_by"] == "Not Equals") {
              return stockValue != filterValue;
            } else if (filter["filter_by"] == "Greater Than") {
              return stockValue > filterValue;
            } else if (filter["filter_by"] == "Lesser Than") {
              return stockValue < filterValue;
            } else {
              return true;
            }
          } else {
            return true;
          }
        } else {
          return true;
        }
      }).toList();
    }

    for (var filter in filters) {
      if (filter["sort"] != Sort.none) {
        stocks = sortStocks(
            field: filter["field"], sort: filter["sort"], stocks: stocks);
      }
    }

    return stocks as List<Map<String, dynamic>>;
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
