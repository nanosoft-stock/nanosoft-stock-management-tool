import 'package:intl/intl.dart';
import 'package:stock_management_tool/core/constants/constants.dart';
import 'package:stock_management_tool/core/constants/enums.dart';
import 'package:stock_management_tool/core/helper/add_new_item_location_history_helper.dart';
import 'package:stock_management_tool/core/local_database/local_database.dart';
import 'package:stock_management_tool/core/local_database/models/stock_hive_model.dart';
import 'package:stock_management_tool/core/services/firestore.dart';
import 'package:stock_management_tool/core/services/injection_container.dart';
import 'package:stock_management_tool/features/locate_stock/domain/repositories/locate_stock_repository.dart';
import 'package:uuid/uuid.dart';

class LocateStockRepositoryImplementation implements LocateStockRepository {
  LocateStockRepositoryImplementation(this._localDB);

  final LocalDatabase _localDB;

  // final Map locatedStock = {
  //   "all_ids": {
  //     "Item Id": [],
  //     "Container Id": [],
  //     "Warehouse Location Id": [],
  //   },
  //   "selected_item_ids": [],
  //   "rows": [
  //     {
  //       "search_by": "",
  //       "show_table": "",
  //       "view_mode": "",
  //       "chosen_ids": [],
  //       "filters": [],
  //       "items": [
  //         {
  //           "item_id": "",
  //           "container_id": "",
  //           "warehouse_location_id": "",
  //           "state": "",
  //         },
  //       ],
  //       "containers": [
  //         {
  //           "item_quantity": "",
  //           "container_id": "",
  //           "warehouse_location_id": "",
  //           "state": "",
  //         },
  //       ],
  //       "warehouse_locations": [
  //         {
  //           "item_quantity": "",
  //           "container_quantity": "",
  //           "warehouse_location_id": "",
  //           "state": "",
  //         },
  //       ],
  //     },
  //   ]
  // };

  // List fieldsOrder = [
  //   "date",
  //   "category",
  //   "warehouse location",
  //   "container id",
  //   "item id",
  //   "serial number",
  //   "sku",
  //   "make",
  //   "model",
  //   "processor",
  //   "ram",
  //   "storage",
  //   "screen resolution",
  //   "os",
  //   "screen size",
  //   "usb c",
  //   "hdmi",
  //   "display port",
  //   "vga",
  //   "ethernet",
  //   "usb a",
  //   "type",
  //   "supplier info",
  //   "dispatch info",
  //   "comments",
  //   "user",
  // ];

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
      {required Map locatedStock, required Function(Map) onChange}) {
    _localDB.itemStream().listen((snapshot) {
      locatedStock["all_ids"]["Item Id"] =
          _localDB.items.map((e) => e.itemId!).toList();
    });

    _localDB.containerStream().listen((snapshot) {
      locatedStock["all_ids"]["Container Id"] =
          _localDB.containers.map((e) => e.containerId!).toList();
    });

    _localDB.warehouseLocationStream().listen((snapshot) {
      locatedStock["all_ids"]["Warehouse Location Id"] = _localDB
          .warehouseLocations
          .map((e) => e.warehouseLocationId!)
          .toList();
    });

    _localDB.stockStream().listen((snapshot) {
      locatedStock["rows"].forEach((element) {
        if (element["chosen_ids"] != null && element["chosen_ids"].isNotEmpty) {
          Map details = getChosenIdsDetails(
            searchBy: element["search_by"],
            chosenIds: element["chosen_ids"],
            selectedItemIds: locatedStock["selected_item_ids"],
          );

          element["items"] = details["items"];
          element["containers"] = details["containers"];
          element["warehouse_locations"] = details["warehouse_locations"];
        }
      });
      onChange(locatedStock);
    });

    // _objectBox.getStockLocationHistoryStream().listen((snapshot) {
    //   if (snapshot.isNotEmpty) {
    //     locatedStock["pending_state_items"] = getAllPendingStateItems(
    //         locatedStock["pending_state_items"] ?? <String, dynamic>{});
    //     locatedStock["completed_state_items"] = getAllCompletedStateItems();
    //     onChange(locatedStock);
    //   }
    // });
  }

  @override
  Map<String, dynamic> getAllIds() {
    Map<String, dynamic> data = {};

    data["Item Id"] = _localDB.items.map((e) => e.itemId!).toList()
      ..sort((a, b) => compareWithBlank(Sort.asc, a, b));
    data["Container Id"] = _localDB.containers
        .map((e) => e.containerId!)
        .toList()
      ..sort((a, b) => compareWithBlank(Sort.asc, a, b));
    data["Warehouse Location Id"] = _localDB.warehouseLocations
        .map((e) => e.warehouseLocationId!)
        .toList()
      ..sort((a, b) => compareWithBlank(Sort.asc, a, b));

    return data;
  }

  List<Map<String, dynamic>> getAllStocks() {
    List stocks = _localDB.stocks.map((e) => e.toMap()).toList();

    stocks.sort((a, b) => b["date"].compareTo(a["date"]));

    for (var e in stocks) {
      e["date"] = DateFormat('dd-MM-yyyy')
          .format(DateTime.parse(e["date"].toString().toUpperCase()));
    }

    return stocks.cast<Map<String, dynamic>>();
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
  Map<String, dynamic> getInitialFilters() {
    List fields = (_localDB.categoryFields.toList()
          ..sort((a, b) => a.displayOrder!.compareTo(b.displayOrder!)))
        .map((e) => e.field)
        .toSet()
        .toList();

    // List newFields = [...fieldsOrder];
    // newFields.removeWhere((e) => !fields.contains(e));
    // fields = newFields;

    List stocks = getAllStocks();

    Map<String, dynamic> filters = {};

    for (var field in fields) {
      filters[field] = {
        "field": field,
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

    return stocks as List<Map<String, dynamic>>;
  }

  @override
  Map<String, dynamic> getChosenIdsDetails({
    required String searchBy,
    required List chosenIds,
    required List selectedItemIds,
  }) {
    Map<String, dynamic> details = {};
    details["items"] = [];

    for (String _ in chosenIds) {
      List stocks = [];

      // if (searchBy == "Item Id") {
      //   Query query = _objectBox.stockModelBox!
      //       .query(StockObjectBoxModel_.itemId.equals(id))
      //       .build();
      //   stocks = query.find() as List<StockObjectBoxModel>;
      //   query.close();
      // } else if (searchBy == "Container Id") {
      //   Query query = _objectBox.stockModelBox!
      //       .query(StockObjectBoxModel_.containerId.equals(id))
      //       .build();
      //   stocks = query.find() as List<StockObjectBoxModel>;
      //   query.close();
      // } else if (searchBy == "Warehouse Location Id") {
      //   Query query = _objectBox.stockModelBox!
      //       .query(StockObjectBoxModel_.warehouseLocationId.equals(id))
      //       .build();
      //   stocks = query.find() as List<StockObjectBoxModel>;
      //   query.close();
      // }

      details["items"].addAll(stocks
          .map((e) => {
                "item_id": e.itemId,
                "container_id": e.containerId,
                "warehouse_location_id": e.warehouseLocationId,
                "state": selectedItemIds.contains(e.itemId)
                    ? CheckBoxState.all
                    : CheckBoxState.empty,
              })
          .toList());
    }

    List uniqueContainers =
        details["items"].map((e) => e["container_id"]).toSet().toList();

    details["containers"] = uniqueContainers
        .map((e) => {
              "item_quantity": details["items"]
                  .where((element) => element["container_id"] == e)
                  .length
                  .toString(),
              "container_id": e,
              "warehouse_location_id": details["items"].firstWhere((element) =>
                  element["container_id"] == e)["warehouse_location_id"],
              "state": getCheckBoxState(
                key: "container_id",
                id: e,
                items: details["items"],
              ),
            })
        .toList();

    List uniqueWarehouseLocations = details["items"]
        .map((e) => e["warehouse_location_id"])
        .toSet()
        .toList();

    details["warehouse_locations"] = uniqueWarehouseLocations
        .map((e) => {
              'item_quantity': details["items"]
                  .where((element) => element["warehouse_location_id"] == e)
                  .length
                  .toString(),
              "container_quantity": details["containers"]
                  .where((element) => element["warehouse_location_id"] == e)
                  .length
                  .toString(),
              "warehouse_location_id": e,
              "state": getCheckBoxState(
                key: "warehouse_location_id",
                id: e,
                items: details["items"],
              ),
            })
        .toList();

    return details;
  }

  @override
  CheckBoxState getCheckBoxState(
      {required String key, required String id, required List items}) {
    CheckBoxState state = CheckBoxState.empty;
    List affected = items.where((element) => element[key] == id).toList();

    if (affected.every((element) => element["state"] == CheckBoxState.all)) {
      state = CheckBoxState.all;
    } else if (affected
        .any((element) => element["state"] == CheckBoxState.all)) {
      state = CheckBoxState.partial;
    } else {
      state = CheckBoxState.empty;
    }

    return state;
  }

  @override
  Map<String, dynamic> changeAllStockState({
    required Map locatedStock,
  }) {
    List selectedItemIds = locatedStock["selected_item_ids"];

    for (int i = 0; i < locatedStock["rows"].length; i++) {
      if (locatedStock["rows"][i]["items"] != null &&
          locatedStock["rows"][i]["items"].isNotEmpty) {
        List items = locatedStock["rows"][i]["items"]
            .map((element) => element["item_id"])
            .toList();

        if (selectedItemIds.any((element) => items.contains(element))) {
          for (var element in selectedItemIds) {
            for (var ele in locatedStock["rows"][i]["items"]) {
              if (ele["item_id"] == element) {
                ele["state"] = CheckBoxState.all;
              } else if (!selectedItemIds.contains(ele["item_id"])) {
                ele["state"] = CheckBoxState.empty;
              }
            }
          }
        } else {
          locatedStock["rows"][i]["items"].forEach((ele) {
            ele["state"] = CheckBoxState.empty;
          });
        }

        locatedStock["rows"][i]["containers"].forEach((element) {
          element["state"] = getCheckBoxState(
            key: "container_id",
            id: element["container_id"],
            items: locatedStock["rows"][i]["items"],
          );
        });

        locatedStock["rows"][i]["warehouse_locations"].forEach((element) {
          element["state"] = getCheckBoxState(
              key: "warehouse_location_id",
              id: element["warehouse_location_id"],
              items: locatedStock["rows"][i]["items"]);
        });
      }
    }

    return locatedStock as Map<String, dynamic>;
  }

  @override
  List<Map<String, dynamic>> getSelectedIdsDetails(
      {required List selectedItemIds}) {
    List<Map<String, dynamic>> details = [];
    for (var id in selectedItemIds) {
      List stocks =
          _localDB.stocks.where((element) => element.itemId == id).toList();
      // Query query = _objectBox.stockModelBox!
      //     .query(StockObjectBoxModel_.itemId.equals(id))
      //     .build();
      // StockObjectBoxModel stock = query.findFirst();
      // query.close();

      StockHiveModel? stock;

      if (stocks.isNotEmpty) {
        stock = stocks.first;
      }
      details.add(stock != null
          ? {
              "item_id": id,
              "container_id": stock.containerId,
              "warehouse_location_id": stock.warehouseLocationId,
            }
          : {});
    }
    return details;
  }

  @override
  List getContainerIds({required String warehouseLocationId}) {
    Set dataSet = {};
    // Query<ContainerIdObjectBoxModel> query = _objectBox.containerIdBox!
    //     .query(ContainerIdObjectBoxModel_.warehouseLocationId
    //         .equals(warehouseLocationId))
    //     .build();

    // List<ContainerIdObjectBoxModel>? containers = query.find();

    // query.close();

    // for (var element in containers) {
    //   dataSet.add(element.containerId);
    // }

    return dataSet.toList();
  }

  @override
  String getWarehouseLocationId({required String containerId}) {
    // Query<ContainerIdObjectBoxModel> query = _objectBox.containerIdBox!
    //     .query(ContainerIdObjectBoxModel_.containerId.equals(containerId))
    //     .build();

    // ContainerIdObjectBoxModel? container = query.findFirst();

    // query.close();

    // return container?.warehouseLocationId ?? "";
    return "";
  }

  @override
  Future<void> moveItemsToPendingState({required Map selectedItems}) async {
    List items = selectedItems["items"].map((e) => e["item_id"]).toList();

    String groupId = const Uuid().v1();

    if (selectedItems["container_text"] != "") {
      Map data = {
        "group_id": groupId,
        "items": items,
        "container_id": selectedItems["container_text"],
        "warehouse_location_id": selectedItems["warehouse_location_text"],
        "move_type": "container",
        "state": "pending",
      };
      await sl.get<Firestore>().createDocument(
            path: "stock_location_history",
            data: AddNewItemLocationHistoryHelper.toJson(data: data),
          );
    } else {
      List uniqueContainers =
          selectedItems["items"].map((e) => e["container_id"]).toSet().toList();
      for (var element in uniqueContainers) {
        Map data = {
          "group_id": groupId,
          "items": selectedItems["items"]
              .where((e) => e["container_id"] == element)
              .map((e) => e["item_id"])
              .toList(),
          "container_id": element,
          "warehouse_location_id": selectedItems["warehouse_location_text"],
          "move_type": "container",
          "state": "pending",
        };
        await sl.get<Firestore>().createDocument(
              path: "stock_location_history",
              data: AddNewItemLocationHistoryHelper.toJson(data: data),
            );
      }
    }
  }

  @override
  Map<String, dynamic> getAllPendingStateItems(
      Map<String, dynamic> pendingStateItems) {
    // List histories = [];

    // Query query = _objectBox.stockLocationHistoryModelBox!
    //     .query(StockLocationHistoryObjectBoxModel_.state.equals("pending"))
    //     .build();
    // histories = query.find();
    // query.close();

    // histories.sort((a, b) => b.date.compareTo(a.date));

    // List uniqueGroupIds = histories.map((e) => e.groupId).toSet().toList();

    Map data = {};

    // if (histories.isNotEmpty) {
    //   for (var element in uniqueGroupIds) {
    //     data[element] = histories
    //         .where((e) => e.groupId == element)
    //         .map((e) => {
    //               ...e.toJson()..remove("group_id"),
    //               "is_expanded": pendingStateItems.isNotEmpty &&
    //                       pendingStateItems[element] != null
    //                   ? (pendingStateItems[element].firstWhere(
    //                           (ele) => ele["uid"] == e.uid,
    //                           orElse: () =>
    //                               <String, dynamic>{})["is_expanded"] ??
    //                       false)
    //                   : false,
    //             }.cast<String, dynamic>())
    //         .toList()
    //         .cast<Map<String, dynamic>>();
    //   }
    // } else {
    //   data = {};
    // }

    return data.cast<String, dynamic>();
  }

  @override
  Future<void> changeMoveStateToComplete({required List pendingItems}) async {
    // Map warehouseLocations = {};
    // _hive.warehouseLocationModelBox!.values.forEach((e) {
    //   warehouseLocations[e.warehouseLocationId] = null;
    // });

    // Map containers = {};
    // _hive.containerModelBox!.values.forEach((e) {
    //   containers[e.containerId] = e.toMap()..remove("container_id");
    // });

    // Map items = {};
    // _hive.itemModelBox!.values.forEach((e) {
    //   items[e.itemId] = e.toMap()..remove("item_id");
    // });

    // for (var e in pendingItems) {
    //   await sl.get<Firestore>().modifyDocument(
    //         path: "stock_location_history",
    //         uid: e["uid"],
    //         updateMask: ["state"],
    //         data: !kIsLinux
    //             ? {
    //                 "state": "completed",
    //               }
    //             : {
    //                 "state": {
    //                   "stringValue": "completed",
    //                 },
    //               },
    //       );
    // }

    // for (var element in pendingItems) {
    //   for (var e in element["items"]) {
    //     Query query = _objectBox.itemIdBox!
    //         .query(ItemIdObjectBoxModel_.itemId.equals(e))
    //         .build();

    //     ItemIdObjectBoxModel item = query.findFirst();

    //     query.close();
    //     await sl.get<Firestore>().modifyDocument(
    //         path: "stock_data",
    //         uid: item.docRef!,
    //         data: !kIsLinux
    //             ? {
    //                 "container id": element["container_id"],
    //                 "warehouse location id": element["warehouse_location_id"],
    //               }
    //             : {
    //                 "container id": {
    //                   "stringValue": element["container_id"],
    //                 },
    //                 "warehouse location id": {
    //                   "stringValue": element["warehouse_location_id"],
    //                 },
    //               });

    //     items[item.itemId]["container_id"] = element["container_id"];
    //   }

    //   containers[element["container_id"]]["warehouse_location_id"] =
    //       element["warehouse_location_id"];

    //   warehouseLocations[element["warehouse_location_id"]] = null;
    // }

    // await _addNewLocation(
    //   locations: warehouseLocations,
    //   uid: warehouseLocationIdUid,
    //   updateField: "warehouse_location_id",
    // );

    // await _addNewLocation(
    //   locations: containers,
    //   uid: containerIdUid,
    //   updateField: "container_id",
    // );

    // await _addNewLocation(
    //   locations: items,
    //   uid: itemIdUid,
    //   updateField: "item_id",
    // );
  }

  @override
  Future<void> cancelPendingMove({required List pendingItems}) async {
    for (var e in pendingItems) {
      await sl.get<Firestore>().modifyDocument(
            path: "stock_location_history",
            uid: e["uid"],
            updateMask: ["state"],
            data: !kIsLinux
                ? {
                    "state": "canceled",
                  }
                : {
                    "state": {
                      "stringValue": "canceled",
                    },
                  },
          );
    }
  }

  Future<void> _addNewLocation({
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

  @override
  Map<String, dynamic> getAllCompletedStateItems() {
    // List histories = [];

    // Query query = _objectBox.stockLocationHistoryModelBox!
    //     .query(StockLocationHistoryObjectBoxModel_.state.equals("completed"))
    //     .build();
    // histories = query.find();
    // query.close();

    // histories.sort((a, b) => b.date.compareTo(a.date));

    // List uniqueGroupIds = histories.map((e) => e.groupId).toSet().toList();

    Map data = {};

    // if (histories.isNotEmpty) {
    //   for (var element in uniqueGroupIds) {
    //     data[element] = histories
    //         .where((e) => e.groupId == element)
    //         .map((e) => {
    //               ...e.toJson()..remove("group_id"),
    //               "is_expanded": false,
    //             }.cast<String, dynamic>())
    //         .toList()
    //         .cast<Map<String, dynamic>>();
    //   }
    // } else {
    //   data = {};
    // }

    return data.cast<String, dynamic>();
  }
}
