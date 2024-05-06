import 'package:stock_management_tool/constants/constants.dart';
import 'package:stock_management_tool/constants/enums.dart';
import 'package:stock_management_tool/core/data/local_database/models/stock_objectbox_model.dart';
import 'package:stock_management_tool/features/locate_stock/domain/repositories/locate_stock_repository.dart';
import 'package:stock_management_tool/helper/add_new_item_location_history_helper.dart';
import 'package:stock_management_tool/injection_container.dart';
import 'package:stock_management_tool/objectbox.dart';
import 'package:stock_management_tool/objectbox.g.dart';
import 'package:stock_management_tool/services/firestore.dart';

class LocateStockRepositoryImplementation implements LocateStockRepository {
  final ObjectBox _objectBox = sl.get<ObjectBox>();

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

  @override
  void listenToCloudDataChange(
      {required Map locatedStock, required void Function(Map) onChange}) {
    _objectBox.getItemIdStream(triggerImmediately: false).listen((snapshot) {
      if (snapshot.isNotEmpty) {
        locatedStock["all_ids"]["Item Id"] =
            snapshot.map((e) => e.itemId).toList();
      }
      onChange(locatedStock);
    });

    _objectBox
        .getContainerIdStream(triggerImmediately: false)
        .listen((snapshot) {
      if (snapshot.isNotEmpty) {
        locatedStock["all_ids"]["Container Id"] =
            snapshot.map((e) => e.containerId).toList();
      }
      onChange(locatedStock);
    });

    _objectBox
        .getWarehouseLocationIdStream(triggerImmediately: false)
        .listen((snapshot) {
      if (snapshot.isNotEmpty) {
        locatedStock["all_ids"]["Warehouse Location Id"] =
            snapshot.map((e) => e.warehouseLocationId).toList();
      }
      onChange(locatedStock);
    });

    _objectBox.getStockStream(triggerImmediately: false).listen((snapshot) {
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
  }

  @override
  Map<String, dynamic> getAllIds() {
    Map<String, dynamic> data = {};

    data["Item Id"] = _objectBox.getItemIds().map((e) => e.itemId).toList();
    data["Container Id"] =
        _objectBox.getContainerIds().map((e) => e.containerId).toList();
    data["Warehouse Location Id"] = _objectBox
        .getWarehouseLocationIds()
        .map((e) => e.warehouseLocationId)
        .toList();

    return data;
  }

  @override
  Map<String, dynamic> getChosenIdsDetails({
    required String searchBy,
    required List chosenIds,
    required List selectedItemIds,
  }) {
    Map<String, dynamic> details = {};
    details["items"] = [];

    for (String id in chosenIds) {
      List stocks = [];

      if (searchBy == "Item Id") {
        Query query = _objectBox.stockModelBox!
            .query(StockObjectBoxModel_.itemId.equals(id))
            .build();
        stocks = query.find() as List<StockObjectBoxModel>;
        query.close();
      } else if (searchBy == "Container Id") {
        Query query = _objectBox.stockModelBox!
            .query(StockObjectBoxModel_.containerId.equals(id))
            .build();
        stocks = query.find() as List<StockObjectBoxModel>;
        query.close();
      } else if (searchBy == "Warehouse Location Id") {
        Query query = _objectBox.stockModelBox!
            .query(StockObjectBoxModel_.warehouseLocation.equals(id))
            .build();
        stocks = query.find() as List<StockObjectBoxModel>;
        query.close();
      }

      details["items"].addAll(stocks
          .map((e) => {
                "item_id": e.itemId,
                "container_id": e.containerId,
                "warehouse_location_id": e.warehouseLocation,
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
      Query query = _objectBox.stockModelBox!
          .query(StockObjectBoxModel_.itemId.equals(id))
          .build();
      StockObjectBoxModel stock = query.findFirst();
      query.close();

      details.add({
        "item_id": id,
        "container_id": stock.containerId,
        "warehouse_location_id": stock.warehouseLocation,
      });
    }
    return details;
  }

  @override
  List getContainerIds({required String warehouseLocationId}) {
    Set dataSet = {};
    Query<StockObjectBoxModel> query = _objectBox.stockModelBox!
        .query(
            StockObjectBoxModel_.warehouseLocation.equals(warehouseLocationId))
        .build();

    List<StockObjectBoxModel>? stocks = query.find();

    query.close();

    for (var element in stocks) {
      dataSet.add(element.containerId);
    }

    return dataSet.toList();
  }

  @override
  String getWarehouseLocationId({required String containerId}) {
    Query<StockObjectBoxModel> query = _objectBox.stockModelBox!
        .query(StockObjectBoxModel_.containerId.equals(containerId))
        .build();

    StockObjectBoxModel? stock = query.findFirst();

    query.close();

    return stock?.warehouseLocation ?? "";
  }

  @override
  Future<void> moveItemsToPendingState({required Map selectedItems}) async {
    List items = selectedItems["items"].map((e) => e["item_id"]).toList();

    Map data = {
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
  }

  @override
  List<Map<String, dynamic>> getAllPendingStateItems() {
    List histories = [];

    Query query = _objectBox.stockLocationHistoryModelBox!
        .query(StockLocationHistoryObjectBoxModel_.state.equals("pending"))
        .build();
    histories = query.find();
    query.close();

    if (histories.isNotEmpty) {
      histories = histories
          .map((e) => e.toJson())
          .toList()
          .cast<Map<String, dynamic>>();
      histories.sort((a, b) => b["date"].compareTo(a["date"]));
    } else {
      histories = histories.cast<Map<String, dynamic>>();
    }

    return histories as List<Map<String, dynamic>>;
  }

  @override
  Future<void> changeMoveStateToComplete({required Map pendingItem}) async {
    await sl.get<Firestore>().modifyDocument(
          path: "stock_location_history",
          uid: pendingItem["uid"],
          updateMask: ["state"],
          data: !kIsLinux
              ? {
                  "state": "completed",
                }
              : {
                  "state": {
                    "stringValue": "completed",
                  },
                },
        );

    for (var element in pendingItem["items"]) {
      Query query = _objectBox.stockModelBox!
          .query(StockObjectBoxModel_.itemId.equals(element))
          .build();
      StockObjectBoxModel stock = query.findFirst();
      await sl.get<Firestore>().modifyDocument(
          path: "stock_data",
          uid: stock.uid!,
          data: !kIsLinux
              ? {
                  "container id": pendingItem["container_id"],
                  "warehouse location": pendingItem["warehouse_location_id"],
                }
              : {
                  "container id": {
                    "stringValue": pendingItem["container_id"],
                  },
                  "warehouse location": {
                    "stringValue": pendingItem["warehouse_location_id"],
                  },
                });
    }

    List allLocations = await _fetchAllLocations();

    Map warehouseLocations = allLocations
        .firstWhere((element) => element.keys.contains("warehouse_locations"));
    Map containers = allLocations
        .firstWhere((element) => element.keys.contains("containers"));

    await _addNewLocations(
      locations: warehouseLocations["warehouse_locations"],
      newValue: pendingItem["warehouse_location_id"],
      uid: warehouseLocations["uid"],
      updateField: "warehouse_locations",
    );

    await _addNewLocations(
      locations: containers["containers"],
      newValue: pendingItem["container_id"],
      uid: containers["uid"],
      updateField: "containers",
    );
  }

  @override
  Future<void> clearPendingMove({required Map pendingItem}) async {
    await sl.get<Firestore>().deleteDocument(
        path: "stock_location_history", uid: pendingItem["uid"]);
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
    if (updateField == "containers") {
      List stockedContainers = _objectBox.getStocks();
      if (stockedContainers.isNotEmpty) {
        stockedContainers =
            stockedContainers.map((e) => e.containerId).toSet().toList();
      }

      if (stockedContainers.length == locations.length &&
          stockedContainers.every((element) => locations.contains(element))) {
        return;
      } else {
        locations = stockedContainers;
        locations.remove(newValue);
      }
    }

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

  @override
  List<Map<String, dynamic>> getAllCompletedStateItems() {
    List histories = [];

    Query query = _objectBox.stockLocationHistoryModelBox!
        .query(StockLocationHistoryObjectBoxModel_.state.equals("completed"))
        .build();
    histories = query.find();
    query.close();

    if (histories.isNotEmpty) {
      histories = histories
          .map((e) => e.toJson())
          .toList()
          .cast<Map<String, dynamic>>();
      histories.sort((a, b) => b["date"].compareTo(a["date"]));
      histories = histories.sublist(0, 10);
    } else {
      histories = histories.cast<Map<String, dynamic>>();
    }

    return histories as List<Map<String, dynamic>>;
  }

// Future<void> _addAllLocations() async {
//   warehouseLocations = warehouseLocations.map((e) => {"stringValue": e.toUpperCase()}).toList();
//
//   await sl.get<Firestore>().createDocument(
//     path: !kIsLinux ? "all_locations" : "",
//     data: {
//       "warehouse_locations": {
//         "arrayValue": {
//           "values": [warehouseLocations],
//         }
//       }
//     },
//   );
//
//   containers = containers.map((e) => {"stringValue": e.toUpperCase()}).toList();
//
//   await sl.get<Firestore>().createDocument(
//     path: "all_locations",
//     data: {
//       "containers": {
//         "arrayValue": {
//           "values": [containers],
//         }
//       }
//     },
//   );
//
//   items = items.map((e) => {"stringValue": e.toUpperCase()}).toList();
//
//   await sl.get<Firestore>().createDocument(
//     path: "all_locations",
//     data: {
//       "items": {
//         "arrayValue": {
//           "values": [items],
//         }
//       }
//     },
//   );
// }
//
// List items = ["901290", "901291", "901292", "901293", "901294", "901295"];
// List containers = ["BOX 4290", "BOX 4291", "BOX 4292", "BOX 4293", "BOX 4294", "BOX 4295"];
// List warehouseLocations = [
//   "A01R01L1A",
//   "A01R01L1B",
//   "A01R01L2A",
//   "A01R01L2B",
//   "A01R01L3A",
//   "A01R01L3B",
//   "A01R01L4A",
//   "A01R01L4B",
//   "A01R02L1A",
//   "A01R02L1B",
//   "A01R02L2B",
//   "A01R02L3A",
//   "A01R02L3B",
//   "A01R02L4A",
//   "A01R02L4B",
//   "A01R03L1A",
//   "A01R03L1B",
//   "A01R03L2B",
//   "A01R03L3A",
//   "A01R03L3B",
//   "A01R03L4A",
//   "A01R03L4B",
//   "A01R04L1A",
//   "A01R04L1B",
//   "A01R04L2B",
//   "A01R04L3A",
//   "A01R04L3B",
//   "A01R04L4A",
//   "A01R04L4B",
//   "A01R05L1A",
//   "A01R05L1B",
//   "A01R05L2B",
//   "A01R05L3A",
//   "A01R05L3B",
//   "A01R05L4A",
//   "A01R05L4B",
//   "A01R06L1A",
//   "A01R06L1B",
//   "A01R06L2B",
//   "A01R06L3A",
//   "A01R06L3B",
//   "A01R06L4A",
//   "A01R06L4B",
//   "A01R07L1A",
//   "A01R07L1B",
//   "A01R07L2B",
//   "A01R07L3A",
//   "A01R07L3B",
//   "A01R07L4A",
//   "A01R07L4B",
//   "A01R08L1A",
//   "A01R08L1B",
//   "A01R08L2B",
//   "A01R08L3A",
//   "A01R08L3B",
//   "A01R08L4A",
//   "A01R08L4B",
//   "A01R09L1A",
//   "A01R09L1B",
//   "A01R09L2B",
//   "A01R09L3A",
//   "A01R09L3B",
//   "A01R09L4A",
//   "A01R09L4B",
//   "A01R10L1A",
//   "A01R10L1B",
//   "A01R10L2B",
//   "A01R10L3A",
//   "A01R10L3B",
//   "A01R10L4A",
//   "A01R10L4B",
//   "A01R11L1A",
//   "A01R11L1B",
//   "A01R11L2B",
//   "A01R11L3A",
//   "A01R11L3B",
//   "A01R11L4A",
//   "A01R11L4B",
//   "A02R01L1A",
//   "A02R01L1B",
//   "A02R01L2A",
//   "A02R01L2B",
//   "A02R01L3A",
//   "A02R01L3B",
//   "A02R01L4A",
//   "A02R01L4B",
//   "A02R02L1A",
//   "A02R02L1B",
//   "A02R02L2B",
//   "A02R02L3A",
//   "A02R02L3B",
//   "A02R02L4A",
//   "A02R02L4B",
//   "A02R03L1A",
//   "A02R03L1B",
//   "A02R03L2B",
//   "A02R03L3A",
//   "A02R03L3B",
//   "A02R03L4A",
//   "A02R03L4B",
//   "A02R04L1A",
//   "A02R04L1B",
//   "A02R04L2B",
//   "A02R04L3A",
//   "A02R04L3B",
//   "A02R04L4A",
//   "A02R04L4B",
//   "A02R05L1A",
//   "A02R05L1B",
//   "A02R05L2B",
//   "A02R05L3A",
//   "A02R05L3B",
//   "A02R05L4A",
//   "A02R05L4B",
//   "A02R06L1A",
//   "A02R06L1B",
//   "A02R06L2B",
//   "A02R06L3A",
//   "A02R06L3B",
//   "A02R06L4A",
//   "A02R06L4B",
//   "A02R07L1A",
//   "A02R07L1B",
//   "A02R07L2B",
//   "A02R07L3A",
//   "A02R07L3B",
//   "A02R07L4A",
//   "A02R07L4B",
//   "A02R08L1A",
//   "A02R08L1B",
//   "A02R08L2B",
//   "A02R08L3A",
//   "A02R08L3B",
//   "A02R08L4A",
//   "A02R08L4B",
//   "A02R09L1A",
//   "A02R09L1B",
//   "A02R09L2B",
//   "A02R09L3A",
//   "A02R09L3B",
//   "A02R09L4A",
//   "A02R09L4B",
//   "A02R10L1A",
//   "A02R10L1B",
//   "A02R10L2B",
//   "A02R10L3A",
//   "A02R10L3B",
//   "A02R10L4A",
//   "A02R10L4B",
//   "A03R01L1B",
//   "A03R01L2A",
//   "A03R01L2B",
//   "A03R01L3A",
//   "A03R01L3B",
//   "A03R01L4A",
//   "A03R01L4B",
//   "A03R02L1A",
//   "A03R02L1B",
//   "A03R02L2B",
//   "A03R02L3A",
//   "A03R02L3B",
//   "A03R02L4A",
//   "A03R02L4B",
//   "A03R03L1A",
//   "A03R03L1B",
//   "A03R03L2B",
//   "A03R03L3A",
//   "A03R03L3B",
//   "A03R03L4A",
//   "A03R03L4B",
//   "A03R04L1A",
//   "A03R04L1B",
//   "A03R04L2B",
//   "A03R04L3A",
//   "A03R04L3B",
//   "A03R04L4A",
//   "A03R04L4B",
//   "A03R05L1A",
//   "A03R05L1B",
//   "A03R05L2B",
//   "A03R05L3A",
//   "A03R05L3B",
//   "A03R05L4A",
//   "A03R05L4B",
//   "A03R06L1A",
//   "A03R06L1B",
//   "A03R06L2B",
//   "A03R06L3A",
//   "A03R06L3B",
//   "A03R06L4A",
//   "A03R06L4B",
//   "A03R07L1A",
//   "A03R07L1B",
//   "A03R07L2B",
//   "A03R07L3A",
//   "A03R07L3B",
//   "A03R07L4A",
//   "A03R07L4B",
//   "A03R08L1A",
//   "A03R08L1B",
//   "A03R08L2B",
//   "A03R08L3A",
//   "A03R08L3B",
//   "A03R08L4A",
//   "A03R08L4B",
//   "A03R09L1A",
//   "A03R09L1B",
//   "A03R09L2B",
//   "A03R09L3A",
//   "A03R09L3B",
//   "A03R09L4A",
//   "A03R09L4B",
//   "A03R10L1A",
//   "A03R10L1B",
//   "A03R10L2B",
//   "A03R10L3A",
//   "A03R10L3B",
//   "A03R10L4A",
//   "A03R10L4B",
//   "DS01L1",
//   "DS01L2",
//   "DS01L3",
//   "DS01L4",
//   "DS01L5",
//   "DS01L6",
//   "MBENCH01",
//   "MBENCH02",
//   "MBENCH03",
//   "MBENCH04",
//   "MBENCH05",
//   "MBENCH06",
//   "MDESK01",
//   "MDESK02",
//   "MS01L1",
//   "MS01L2",
//   "MS01L3",
//   "MS01L4",
//   "MS01L5",
//   "MS02L1",
//   "MS02L2",
//   "MS02L3",
//   "MS02L4",
//   "MS02L5",
//   "MS03L1",
//   "MS03L2",
//   "MS03L3",
//   "MS03L4",
//   "MS03L5",
//   "MS04L1",
//   "MS04L2",
//   "MS04L3",
//   "MS04L4",
//   "MS04L5",
//   "MS05L1",
//   "MS05L2",
//   "MS05L3",
//   "MS05L4",
//   "MS05L5",
//   "MS06L1",
//   "MS06L2",
//   "MS06L3",
//   "MS06L4",
//   "MS06L5",
//   "MS07L1",
//   "MS07L2",
//   "MS07L3",
//   "MS07L4",
//   "MS07L5",
//   "MS08L1",
//   "MS08L2",
//   "MS08L3",
//   "MS08L4",
//   "MS08L5",
//   "MS09L1",
//   "MS09L2",
//   "MS09L3",
//   "MS09L4",
//   "MS09L5",
//   "MS10L1",
//   "MS10L2",
//   "MS10L3",
//   "MS10L4",
//   "MS10L5",
//   "MS11L1",
//   "MS11L2",
//   "MS11L3",
//   "MS11L4",
//   "MS11L5",
//   "MS12L1",
//   "MS12L2",
//   "MS12L3",
//   "MS12L4",
//   "MS12L5",
//   "MS13L1",
//   "MS13L2",
//   "MS13L3",
//   "MS13L4",
//   "MS13L5",
//   "MS14L1",
//   "MS14L2",
//   "MS14L3",
//   "MS14L4",
//   "MS14L5",
//   "OFDESK01",
//   "OFDESK02",
//   "OFDESK03",
//   "OFDESK04",
//   "OS01L1",
//   "OS01L2",
//   "OS01L3",
//   "OS01L4",
//   "OS01L5",
//   "PACKBENCH01",
//   "PACKBENCH02",
//   "RCY MISC",
//   "RCY PARTS",
//   "RCY TFT",
//   "RCYBATTERIES",
//   "SC01L1",
//   "SC01L2",
//   "SC01L3",
//   "SC01L4",
//   "SC01L5",
//   "SC02L1",
//   "SC02L2",
//   "SC02L3",
//   "SC02L4",
//   "SC02L5",
//   "SC03L1",
//   "SC03L2",
//   "SC03L3",
//   "SC03L4",
//   "SC03L5",
//   "SC04L1",
//   "SC04L2",
//   "SC04L3",
//   "SC04L4",
//   "SC04L5",
//   "SC05L1",
//   "SC05L2",
//   "SC05L3",
//   "SC05L4",
//   "SC05L5",
//   "SC06L1",
//   "SC06L2",
//   "SC06L3",
//   "SC06L4",
//   "SC06L5",
//   "SF01L1",
//   "SF01L2",
//   "SF01L3",
//   "SF01L4",
//   "SF01L5",
//   "SHUTTER 1",
//   "SHUTTER 2",
//   "TBENCH01",
//   "TBENCH02",
//   "TBENCH03",
//   "TBENCH04",
//   "TBENCH05",
//   "TBENCH06",
//   "TBENCH07",
//   "TBENCH08",
//   "TDESK01",
//   "TDESK02",
//   "TECHBAY01",
//   "TECHBAY02",
//   "TECHBAY03",
//   "TECHBAY04",
//   "TECHBAY05",
//   "TECHBAY06",
//   "TS01L1",
//   "TS01L2",
//   "TS01L3",
//   "TS01L4",
//   "TS01L5",
//   "TS02L1",
//   "TS02L2",
//   "TS02L3",
//   "TS02L4",
//   "TS02L5",
//   "TS03L1",
//   "TS03L2",
//   "TS03L3",
//   "TS03L4",
//   "TS03L5",
//   "TS04L1",
//   "TS04L2",
//   "TS04L3",
//   "TS04L4",
//   "TS04L5",
//   "TS05L1",
//   "TS05L2",
//   "TS05L3",
//   "TS05L4",
//   "TS05L5",
//   "TS06L1",
//   "TS06L2",
//   "TS06L3",
//   "TS06L4",
//   "TS06L5",
//   "WH1 CHECKING",
//   "WH1 HOLD",
//   "WH1 STAGED",
//   "WH2 CHECKING",
//   "WH2 HOLD",
//   "WH2 STAGED"
// ];
}
