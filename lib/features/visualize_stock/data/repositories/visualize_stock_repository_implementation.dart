import 'dart:async';
import 'dart:io';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
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

  List fieldsOrder = [
    "date",
    "category",
    "warehouse location",
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
    _objectBox.getInputFieldStream().listen((event) {
      onChange(visualizeStock);
    });
  }

  @override
  List<StockFieldModel> getAllFields() {
    List fields = _objectBox.getInputFields().map((e) => e.toJson()).toList();

    List newFields = [];

    for (var ele in fieldsOrder) {
      newFields.add(fields.firstWhere((e) => e["field"] == ele));
    }

    fields = newFields;

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
    if (sort == Sort.asc) {
      stocks.sort((a, b) => _compareWithBlank(sort, a[field], b[field]));
    } else if (sort == Sort.desc) {
      stocks.sort((a, b) => _compareWithBlank(sort, b[field], a[field]));
    }

    return stocks.map((e) => StockModel.fromJson(e).toJson()).toList();
  }

  int _compareWithBlank(sort, a, b) {
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
      data["all_selected"] = true;
      data["all_unique_values"] =
          getUniqueValues(field: ele.field, stocks: stocks);

      data.addAll(getFilterByValuesByDatatype(
          values: stocks
              .map((stock) => stock[ele.field].toString())
              .toList()
              .cast<String>()));

      return data;
    }).toList();
  }

  @override
  List<Map<String, dynamic>> getUniqueValues(
      {required String field, required List stocks}) {
    return stocks
        .map((e) => e[field])
        .toSet()
        .map((e) => {"title": e, "show": true, "selected": true})
        .toList()
      ..sort((a, b) => _compareWithBlank(Sort.asc, a, b));
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
  List<Map<String, dynamic>> getFilteredStocks({required List filters}) {
    List stocks = _objectBox.getStocks().map((e) => e.toJson()).toList();

    for (var filter in filters) {
      stocks = stocks.where((element) {
        if (!filter["all_unique_values"].every((e) => e["selected"] == true)) {
          String stockValue = element[filter["field"]];
          return filter["all_unique_values"]
              .firstWhere((e) => e["title"] == stockValue)["selected"];
        } else if (filter["filter_by"] != "") {
          if (filter["datatype"] == "string") {
            String stockValue =
                element[filter["field"]].toString().toLowerCase();
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
            double? stockValue =
                double.tryParse(element[filter["field"]] ?? "");
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

    Map warehouseLocations = {};
    _objectBox.warehouseLocationIdBox!.getAll().forEach((e) {
      warehouseLocations[e.warehouseLocationId] = null;
    });

    Map containers = {};
    _objectBox.containerIdBox!.getAll().forEach((e) {
      containers[e.containerId] = {
        "warehouse_location_id": e.warehouseLocationId
      };
    });

    Map items = {};
    _objectBox.itemIdBox!.getAll().forEach((e) {
      items[e.itemId] = {
        "container_id": e.containerId,
        "doc_ref": e.docRef
      };
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
              value = cellValue.value;
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

        if (!items.containsKey(rowData["item id"])) {
          if (containers[rowData["container id"]]["warehouse_location_id"] ==
                  rowData["warehouse location"] ||
              (containers[rowData["container id"]]["warehouse_location_id"] ??
                      "") ==
                  "") {
            containers[rowData["container id"]] = {
              "warehouse_location_id": rowData["warehouse location"]
            };
            newStocks.add(AddNewStockHelper.toJson(data: rowData));
            uniqueContainers.add(rowData["container id"]);
          } else {
            // Call Error

            return;
          }
        } else {
          rowData["container id"] = items[rowData["item id"]]["container_id"];
          rowData["warehouse location"] = containers[rowData["container id"]]
                  ["warehouse_location_id"] ??
              "";
          existingStocks.add({
            "doc_ref": items[rowData["item id"]]["doc_ref"],
            ...AddNewStockHelper.toJson(data: rowData),
          });
        }
      }
    }

    if (newStocks.isNotEmpty) {
      Map<String, dynamic> docRefs = await sl.get<Firestore>().batchWrite(
          path: "stock_data", data: newStocks, isToBeUpdated: false);
      if (docRefs.isNotEmpty) {
        docRefs.forEach((k, v) {
          items[k] = v;
        });
      }
    }

    if (existingStocks.isNotEmpty) {
      await sl.get<Firestore>().batchWrite(
          path: "stock_data", data: existingStocks, isToBeUpdated: true);
    }

    await _addNewLocations(
      locations: warehouseLocations,
      newLocations: newStocks
          .map((e) =>
              (e["warehouse location"] ?? "").toString().toUpperCase().trim())
          .toList(),
      uid: warehouseLocationIdUid,
      updateField: "warehouse_location_id",
    );

    await _addNewLocations(
      locations: containers,
      newLocations: newStocks
          .map((e) => (e["container id"] ?? "").toString().toUpperCase().trim())
          .toList(),
      uid: containerIdUid,
      updateField: "container_id",
    );

    await _addNewLocations(
      locations: items,
      newLocations: newStocks
          .map((e) => (e["item id"] ?? "").toString().toUpperCase().trim())
          .toList(),
      uid: itemIdUid,
      updateField: "item_id",
    );

    List locations = [];

    for (var ele in uniqueContainers) {
      locations.add(AddNewItemLocationHistoryHelper.toJson(data: {
        "items": newStocks
            .where((e) => e["container id"] == ele)
            .map((e) => e["item id"])
            .toList(),
        "container_id": ele,
        "warehouse_location": newStocks
            .firstWhere((e) => e["container id"] == ele)["warehouse location"],
        "move_type": "excel import",
        "state": "completed",
      }));
    }

    await sl.get<Firestore>().batchWrite(
        path: "stock_location_history", data: locations, isToBeUpdated: false);

    debugPrint("Import Completed");
  }

  Future<void> _addNewLocations({
    required Map locations,
    required List newLocations,
    required String uid,
    required String updateField,
  }) async {
    Map data = {};

    List tempLocations =
        (locations.keys.toSet()..addAll(newLocations)).toList();

    for (String e in tempLocations) {
      if (updateField == "warehouse_location_id") {
        data[e] = null;
      } else if (updateField == "container_id") {
        data[e] = {
          "warehouse_location_id": locations[e]["warehouse_location_id"] ?? ""
        };
      } else if (updateField == "item_id") {
        data[e] = {
          "container_id": locations[e]["container_id"] ?? "",
          "doc_ref": locations[e]["doc_ref"] ?? ""
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
          cell.value = TextCellValue(field.isTitleCase
              ? field.field.toString().toTitleCase()
              : field.field.toUpperCase());
          column++;
        }
      } else {
        for (var field in fields) {
          var cell = sheetObject.cell(
              CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row));
          cell.value = TextCellValue(stocks[row - 1][field.field].toString());
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
