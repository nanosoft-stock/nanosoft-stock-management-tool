import 'dart:async';
import 'dart:io';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stock_management_tool/core/constants/constants.dart';
import 'package:stock_management_tool/core/constants/enums.dart';
import 'package:stock_management_tool/core/helper/add_new_item_location_history_helper.dart';
import 'package:stock_management_tool/core/helper/add_new_stock_helper.dart';
import 'package:stock_management_tool/core/services/firestore.dart';
import 'package:stock_management_tool/core/services/injection_container.dart';
import 'package:stock_management_tool/features/visualize_stock/data/models/stock_model.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/repositories/visualize_stock_repository.dart';
import 'package:stock_management_tool/objectbox.dart';
import 'package:uuid/uuid.dart';

class VisualizeStockRepositoryImplementation
    implements VisualizeStockRepository {
  final ObjectBox _objectBox = sl.get<ObjectBox>();

  List fieldsOrder = [
    "date",
    "category",
    "warehouse location id",
    "container id",
    "item id",
    "serial number",
    "sku",
    "make",
    "model",
    "processor",
    "ram",
    "storage",
    "screen resolution",
    "os",
    "screen size",
    "usb c",
    "hdmi",
    "display port",
    "vga",
    "ethernet",
    "usb a",
    "type",
    "supplier info",
    "dispatch info",
    "comments",
    "staff",
    "archived",
  ];

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
    // "Between"
  ];

  @override
  void listenToCloudDataChange(
      {required Map visualizeStock, required Function(Map) onChange}) async {
    _objectBox.getInputFieldStream().listen((snapshot) {
      onChange(visualizeStock);
    });

    _objectBox.getStockStream().listen((snapshot) {
      visualizeStock["stocks"] =
          getFilteredStocks(filters: visualizeStock["filters"]);
      onChange(visualizeStock);
    });
  }

  @override
  List<String> getAllFields() {
    List fields = _objectBox.getInputFields().map((e) => e.field).toList();

    List newFields = [...fieldsOrder];
    newFields.removeWhere((e) => !fields.contains(e));

    return newFields.cast<String>();
  }

  @override
  List<Map<String, dynamic>> getAllStocks() {
    List stocks = _objectBox.getStocks();

    stocks.sort((a, b) => b.date.compareTo(a.date));

    stocks = stocks
        .map((e) => StockModel.fromJson(e.toPartialJson()).toJson())
        .toList();

    for (var e in stocks) {
      e["date"] = DateFormat('dd-MM-yyyy')
          .format(DateTime.parse(e["date"].toString().toUpperCase()));
    }

    return stocks.cast<Map<String, dynamic>>();
  }

  @override
  List<Map<String, dynamic>> sortStocks(
      {required String field, required Sort sort, required List stocks}) {
    if (sort == Sort.asc) {
      stocks.sort((a, b) => compareWithBlank(sort, a[field], b[field]));
    } else if (sort == Sort.desc) {
      stocks.sort((a, b) => compareWithBlank(sort, b[field], a[field]));
    }

    return stocks as List<Map<String, dynamic>>;
  }

  @override
  int compareWithBlank(sort, a, b) {
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

  @override
  Map<String, dynamic> getInitialFilters(
      {required List fields, required List stocks}) {
    Map<String, dynamic> filters = {};

    for (var field in fields) {
      filters[field] = {
        "field": field,
        "show_column": true,
        "sort": field != "date" ? Sort.none : Sort.desc,
        "filter_by": "",
        "filter_value": "",
        "search_value": "",
        "all_selected": true,
        ...getUniqueValues(field: field, stocks: stocks),
        ...getFilterByValuesByDatatype(
            values: stocks
                .map((stock) => stock[field].toString())
                .toList()
                .cast<String>()),
      };
    }

    return filters;
  }

  @override
  Map<String, dynamic> getUniqueValues(
      {required String field, required List stocks}) {
    List uniqueValues = stocks.map((e) => e[field]).toSet().toList()
      ..sort((a, b) => compareWithBlank(Sort.asc, a, b));

    Map details = {};
    for (var e in uniqueValues) {
      details[e] = {"title": e, "show": true, "selected": true};
    }

    return {
      "unique_values": uniqueValues,
      "unique_values_details": details,
    };
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
  }

  @override
  List<Map<String, dynamic>> getFilteredStocks({required Map filters}) {
    List stocks = getAllStocks();

    filters.forEach((field, filter) {
      stocks = stocks.where((element) {
        if (!filter["unique_values_details"]
            .values
            .every((e) => e["selected"] == true)) {
          String stockValue = element[field];
          return filter["unique_values_details"][stockValue]["selected"];
        } else if (filter["filter_by"] != "") {
          if (filter["datatype"] == "string") {
            String stockValue = element[field].toString().toLowerCase();
            String filterValue =
                filter["filter_value"].toString().toLowerCase();

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
            double? stockValue = double.tryParse(element[field] ?? "");
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
        } else {
          return true;
        }
      }).toList();
    });

    filters.forEach((field, filter) {
      if (filter["sort"] != Sort.none) {
        stocks = sortStocks(field: field, sort: filter["sort"], stocks: stocks);
      }
    });

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

    Map warehouseLocations = {};
    _objectBox.warehouseLocationIdBox!.getAll().forEach((e) {
      warehouseLocations[e.warehouseLocationId] = null;
    });

    Map containers = {};
    _objectBox.containerIdBox!.getAll().forEach((e) {
      containers[e.containerId] = e.toJson()..remove("container_id");
    });

    Map items = {};
    _objectBox.itemIdBox!.getAll().forEach((e) {
      items[e.itemId] = e.toJson()..remove("item_id");
    });

    List header = [];
    List newStocks = [];
    List existingStocks = [];
    Set uniqueContainers = {};

    for (var table in excel.tables.keys) {
      for (var cell in excel.tables[table]!.rows.first) {
        header.add((cell!.value! as TextCellValue).value.toLowerCase());
      }

      for (var row in excel.tables[table]!.rows.sublist(1)) {
        Map<String, dynamic> rowData = {};

        for (int i = 0; i < row.length; i++) {
          final cellValue = row[i]?.value;

          Object? value;

          switch (cellValue) {
            case null:
              value = null;
              break;
            case TextCellValue():
              value = cellValue.value.toString();
              break;
            case IntCellValue():
              value = cellValue.value.toString();
              break;
            case BoolCellValue():
              value = cellValue.value.toString();
              break;
            case DoubleCellValue():
              value = cellValue.value.toString();
              break;
            case DateCellValue():
              break;
            case TimeCellValue():
              break;
            case DateTimeCellValue():
              break;
            default:
              break;
          }

          rowData[header[i]] = value;
        }

        String? i = rowData["item id"];
        String? c = rowData["container id"];

        if (!items.containsKey(i)) {
          if (containers[c] != null) {
            rowData["warehouse location id"] =
                containers[c]["warehouse_location_id"] ?? "";
          } else {
            containers[c] = {"warehouse_location_id": "", "status": "added"};
            rowData["warehouse location id"] = "";
          }

          newStocks.add(AddNewStockHelper.toJson(data: rowData));
          uniqueContainers.add(c);
        } else {
          rowData["container id"] = items[i]["container_id"];
          c = rowData["container id"];
          rowData["warehouse location id"] =
              containers[c]["warehouse_location_id"] ?? "";

          existingStocks.add({
            "doc_ref": items[i]["doc_ref"],
            ...AddNewStockHelper.toJson(data: rowData),
          });
        }
      }
    }

    debugPrint("Data read successful");

    if (newStocks.isNotEmpty) {
      Map<String, dynamic> docRefs = await sl.get<Firestore>().batchWrite(
          path: "stock_data", data: newStocks, isToBeUpdated: false);
      if (docRefs.isNotEmpty) {
        docRefs.forEach((k, v) {
          items[k] = v;
          items[k]["status"] = "added";
        });
      }
    }

    debugPrint("Batch write successful");

    if (existingStocks.isNotEmpty) {
      await sl.get<Firestore>().batchWrite(
          path: "stock_data", data: existingStocks, isToBeUpdated: true);
    }

    debugPrint("Batch modify successful");

    await _addNewLocations(
      locations: containers,
      uid: containerIdUid,
      updateField: "container_id",
    );

    await _addNewLocations(
      locations: items,
      uid: itemIdUid,
      updateField: "item_id",
    );

    debugPrint("Add New locations successful");

    List locations = [];

    String groupId = const Uuid().v1();

    for (var ele in uniqueContainers) {
      locations.add(AddNewItemLocationHistoryHelper.toJson(data: {
        "group_id": groupId,
        "items": newStocks
            .where((e) => e["container id"] == ele)
            .map((e) => e["item id"])
            .toList(),
        "container_id": ele,
        "warehouse_location_id": containers[ele] != null
            ? containers[ele]["warehouse_location_id"] ?? ""
            : "",
        "move_type": "excel import",
        "state": "completed",
      }));
    }

    await sl.get<Firestore>().batchWrite(
        path: "stock_location_history", data: locations, isToBeUpdated: false);

    debugPrint("Add Stock Location History successful");

    await _addNewFieldItems(stocks: newStocks..addAll(existingStocks));

    debugPrint("Add New Field Items successful");

    debugPrint("Import successful");
  }

  Future<void> _addNewLocations({
    required Map locations,
    required String uid,
    required String updateField,
  }) async {
    Map data = {};

    List tempLocations = locations.keys.toSet().toList();

    for (String e in tempLocations) {
      if (updateField == "warehouse_location_id") {
        data[e] = null;
      } else if (updateField == "container_id") {
        data[e] = {
          "status": locations[e]["status"] ?? "",
          "warehouse_location_id": locations[e]["warehouse_location_id"] ?? "",
        };
      } else if (updateField == "item_id") {
        data[e] = {
          "container_id": locations[e]["container_id"] ?? "",
          "doc_ref": locations[e]["doc_ref"] ?? "",
          "status": locations[e]["status"] ?? "",
        };
      }
    }

    await sl.get<Firestore>().modifyDocument(
          path: "unique_values",
          uid: uid,
          updateMask: [updateField],
          data: !kIsLinux
              ? {
                  updateField: data,
                }
              : {
                  updateField: {
                    "mapValue": {
                      "fields": {
                        data.map(
                          (k, v) => MapEntry(
                            k,
                            v != null
                                ? {
                                    "mapValue": {
                                      "fields": v.map(
                                        (k1, v1) => MapEntry(
                                          k1,
                                          {
                                            "stringValue": v1,
                                          },
                                        ),
                                      ),
                                    },
                                  }
                                : null,
                          ),
                        )
                      }
                    }
                  }
                },
        );
  }

  Future<void> _addNewFieldItems({required List stocks}) async {
    List uniqueCategories =
        stocks.toSet().map((e) => (e["category"] ?? "").trim()).toList();

    uniqueCategories.removeWhere((e) => e == "");

    List modifiedFields = [];

    for (var category in uniqueCategories) {
      List fields = _objectBox
          .getInputFields()
          .where((e) =>
              e.category?.toLowerCase() == category.toLowerCase() &&
              e.inSku == true &&
              e.items != null &&
              !["category", "sku"].contains(e.field))
          .map((e) => e.toJson())
          .toList();

      for (var field in fields) {
        List<String> values = stocks
            .toSet()
            .where((e) => e["category"] == category)
            .map((e) => e[field["field"]])
            .toList()
            .cast<String>();

        values.removeWhere((e) => e == "");

        if (values.any((e) => !field["items"].contains(e))) {
          String docRef = field["uid"];
          List items = ((field["items"] as List<String>).toSet()
                ..addAll(values))
              .toList()
              .cast<String>()
            ..sort((a, b) => a.compareTo(b));

          modifiedFields.add({
            "doc_ref": docRef,
            "items": items,
            ...(field
              ..remove("items")
              ..remove("uid")),
          });
        }
      }
    }

    if (modifiedFields.isNotEmpty) {
      await sl.get<Firestore>().batchWrite(
          path: "category_fields", data: modifiedFields, isToBeUpdated: true);
    }
  }

  @override
  Future<void> exportToExcel(
      {required List fields, required List stocks}) async {
    Excel excel = Excel.createExcel();

    excel.rename("Sheet1", "Stock");
    Sheet sheetObject = excel["Stock"];

    int column = 0;
    int row = 0;
    while (row <= stocks.length) {
      column = 0;
      if (row == 0) {
        for (var field in fields) {
          var cell = sheetObject.cell(
              CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row));
          cell.value = TextCellValue(field.toTitleCase());
          column++;
        }
      } else {
        for (var field in fields) {
          var cell = sheetObject.cell(
              CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row));
          cell.value = TextCellValue(stocks[row - 1][field].toString());
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
