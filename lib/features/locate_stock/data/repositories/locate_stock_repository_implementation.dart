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

  @override
  Future<List> getIds({required String searchBy}) async {
    // List allLocations = await _fetchAllLocations();
    //
    // print(allLocations);

    if (searchBy == "Warehouse Location Id") {
      return _objectBox
          .getWarehouseLocationIds()
          .map((e) => e.toJson()["warehouse_location_id"])
          .toList();
      // return allLocations.firstWhere((element) =>
      //     element.keys.contains("warehouse_locations"))["warehouse_locations"];
    } else if (searchBy == "Container Id") {
      return _objectBox
          .getContainerIds()
          .map((e) => e.toJson()["container_id"])
          .toList();
      // return allLocations.firstWhere(
      //     (element) => element.keys.contains("containers"))["containers"];
    } else if (searchBy == "Item Id") {
      return _objectBox.getItemIds().map((e) => e.toJson()["item_id"]).toList();
      // return allLocations
      //     .firstWhere((element) => element.keys.contains("items"))["items"];
    }

    return [];
  }

  @override
  Future<List> getIdSpecificData(
      {required String searchBy, required List selectedIds}) async {
    List selectedIdDetails = [];

    for (var id in selectedIds) {
      List data = [];

      if (searchBy == "Warehouse Location Id") {
        data = await _fetchWarehouseLocationDetails(id: id);
      } else if (searchBy == "Container Id") {
        data = await _fetchContainerDetails(id: id);
      } else if (searchBy == "Item Id") {
        data = await _fetchItemDetails(id: id);
      }

      if (data.isNotEmpty) {
        for (var element in data) {
          selectedIdDetails.add(element);
        }
      }
    }

    selectedIdDetails = selectedIdDetails.toSet().toList();

    return selectedIdDetails;
  }

  // Future<List> _fetchAllLocations() async {
  //   List allLocations = await sl
  //       .get<Firestore>()
  //       .getDocuments(path: "all_locations", includeDocRef: true);
  //
  //   allLocations = allLocations.map((element) {
  //     Map map = {};
  //
  //     for (var key in element.keys) {
  //       if (!kIsLinux) {
  //         if (key == "docRef") {
  //           map["docRef"] = element["docRef"];
  //         } else {
  //           map[key] = element[key];
  //         }
  //       } else {
  //         if (key == "docRef") {
  //           map["docRef"] = element["docRef"]["stringValue"];
  //         } else {
  //           map[key] = element[key]["arrayValue"]["values"]
  //               .map((ele) => ele["stringValue"])
  //               .toList();
  //         }
  //       }
  //     }
  //
  //     return map;
  //   }).toList();
  //
  //   return allLocations;
  // }

  Future<List> _fetchWarehouseLocationDetails({required String id}) async {
    List dataList = [];

    Query<StockObjectBoxModel> query = _objectBox.stockModelBox!
        .query(StockObjectBoxModel_.warehouseLocation.equals(id))
        .build();

    List<StockObjectBoxModel> list = query.find();

    query.close();

    if (list.isNotEmpty) {
      for (var element in list) {
        dataList.add({
          "id": element.itemId,
          "container_id": element.containerId,
          "warehouse_location_id": element.warehouseLocation,
          "item_quantity": list.length,
          "container_quantity":
              list.map((e) => e.containerId).toSet().toList().length,
          "is_selected": CheckBoxState.empty,
        });
      }
      dataList.sort((a, b) => a["id"].compareTo(b["id"]));
    }

    // // Cloud
    // List list = await sl.get<Firestore>().filterQuery(
    //   path: "",
    //   query: {
    //     "from": [
    //       {
    //         "collectionId": "stock_data",
    //         "allDescendants": false,
    //       }
    //     ],
    //     "where": {
    //       "fieldFilter": {
    //         "field": {
    //           "fieldPath":
    //               !kIsLinux ? "warehouse location" : "`warehouse location`",
    //         },
    //         "op": "EQUAL",
    //         "value": {
    //           "stringValue": id,
    //         },
    //       },
    //     },
    //   },
    // );
    //
    // if (list.isNotEmpty && list.first.isNotEmpty) {
    //   for (var e in list) {
    //     if (!kIsLinux) {
    //       dataList.add({
    //         "id": e["item id"],
    //         "container_id": e["container id"],
    //         "warehouse_location_id": id,
    //         "item_quantity": list.length,
    //         "container_quantity": list
    //             .map((element) => element["container id"])
    //             .toSet()
    //             .toList()
    //             .length,
    //         "is_selected": CheckBoxState.empty,
    //       });
    //     } else {
    //       dataList.add({
    //         "id": e["item id"]["stringValue"],
    //         "container_id": e["container id"]["stringValue"],
    //         "warehouse_location_id": id,
    //         "item_quantity": list.length,
    //         "container_quantity": list
    //             .map((element) => element["container id"]["stringValue"])
    //             .toSet()
    //             .toList()
    //             .length,
    //         "is_selected": CheckBoxState.empty,
    //       });
    //     }
    //   }
    //
    //   dataList.sort((a, b) => a["id"].compareTo(b["id"]));
    // }

    return dataList;
  }

  Future<List> _fetchContainerDetails({required String id}) async {
    List dataList = [];

    Query<StockObjectBoxModel> query = _objectBox.stockModelBox!
        .query(StockObjectBoxModel_.containerId.equals(id))
        .build();

    List<StockObjectBoxModel> list = query.find();

    query.close();

    if (list.isNotEmpty) {
      for (var element in list) {
        dataList.add({
          "id": element.itemId,
          "container_id": element.containerId,
          "warehouse_location_id": element.warehouseLocation,
          "item_quantity": list.length,
          "is_selected": CheckBoxState.empty,
        });
      }
      dataList.sort((a, b) => a["id"].compareTo(b["id"]));
    }

    // // Cloud
    // List list = await sl.get<Firestore>().filterQuery(
    //   path: "",
    //   query: {
    //     "from": [
    //       {
    //         "collectionId": "stock_data",
    //         "allDescendants": false,
    //       }
    //     ],
    //     "where": {
    //       "fieldFilter": {
    //         "field": {
    //           "fieldPath": !kIsLinux ? "container id" : "`container id`",
    //         },
    //         "op": "EQUAL",
    //         "value": {
    //           "stringValue": id,
    //         },
    //       },
    //     },
    //   },
    // );
    //
    // if (list.isNotEmpty && list.first.isNotEmpty) {
    //   for (var e in list) {
    //     if (!kIsLinux) {
    //       dataList.add({
    //         "id": e["item id"],
    //         "container_id": id,
    //         "warehouse_location_id": list.first["warehouse location"],
    //         "item_quantity": list.length,
    //         "is_selected": CheckBoxState.empty,
    //       });
    //     } else {
    //       dataList.add({
    //         "id": e["item id"]["stringValue"],
    //         "container_id": id,
    //         "warehouse_location_id": list.first["warehouse location"]
    //             ["stringValue"],
    //         "item_quantity": list.length,
    //         "is_selected": CheckBoxState.empty,
    //       });
    //     }
    //   }
    //
    //   dataList.sort((a, b) => a["id"].compareTo(b["id"]));
    // }

    return dataList;
  }

  Future<List> _fetchItemDetails({required String id}) async {
    List dataList = [];

    Query<StockObjectBoxModel> query = _objectBox.stockModelBox!
        .query(StockObjectBoxModel_.itemId.equals(id))
        .build();

    StockObjectBoxModel? stock = query.findFirst();

    query.close();

    if (stock != null) {
      dataList.add({
        "id": stock.itemId,
        "container_id": stock.containerId,
        "warehouse_location_id": stock.warehouseLocation,
        "is_selected": CheckBoxState.empty,
      });
    }

    // // Cloud
    // List list = await sl.get<Firestore>().filterQuery(
    //   path: "",
    //   query: {
    //     "from": [
    //       {
    //         "collectionId": "stock_data",
    //         "allDescendants": false,
    //       }
    //     ],
    //     "where": {
    //       "fieldFilter": {
    //         "field": {
    //           "fieldPath": !kIsLinux ? "item id" : "`item id`",
    //         },
    //         "op": "EQUAL",
    //         "value": {
    //           "stringValue": id,
    //         },
    //       },
    //     },
    //   },
    // );
    //
    // if (list.isNotEmpty && list.first.isNotEmpty) {
    //   for (var e in list) {
    //     if (!kIsLinux) {
    //       dataList.add({
    //         'id': id,
    //         "container_id": e["container id"],
    //         "warehouse_location_id": e["warehouse location"],
    //         "is_selected": CheckBoxState.empty,
    //       });
    //     } else {
    //       dataList.add({
    //         'id': id,
    //         "container_id": e["container id"]["stringValue"],
    //         "warehouse_location_id": e["warehouse location"]["stringValue"],
    //         "is_selected": CheckBoxState.empty,
    //       });
    //     }
    //   }
    // }

    return dataList;
  }

  @override
  Future<List> getContainerIds({required String warehouseLocationId}) async {
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
  Future<String> getWarehouseLocationId({required String containerId}) async {
    Query<StockObjectBoxModel> query = _objectBox.stockModelBox!
        .query(StockObjectBoxModel_.containerId.equals(containerId))
        .build();

    StockObjectBoxModel? stock = query.findFirst();

    query.close();

    return stock!.warehouseLocation ?? "";
  }

  @override
  Future listenToCloudDataChange(
      {required List locatedItems,
      required Map selectedItems,
      required Function(List, Map) onChange}) async {
    // _objectBox.getStockStream(triggerImmediately: true).listen((event) {
    //   onChange([], {});
    // });
    _objectBox.getItemIdStream(triggerImmediately: false).listen((event) {
      locatedItems.forEach((element) async {
        if (element["search_by"] == "Item Id") {
          element["all_ids"] = await getIds(searchBy: element["search_by"]);
        }
      });

      onChange(locatedItems, selectedItems);
    });
    _objectBox.getContainerIdStream(triggerImmediately: false).listen((event) {
      locatedItems.forEach((element) async {
        if (element["search_by"] == "Container Id") {
          element["all_ids"] = await getIds(searchBy: element["search_by"]);
        }
      });

      onChange(locatedItems, selectedItems);
    });
    _objectBox
        .getWarehouseLocationIdStream(triggerImmediately: false)
        .listen((event) {
      locatedItems.forEach((element) async {
        if (element["search_by"] == "Warehouse Location Id") {
          element["all_ids"] = await getIds(searchBy: element["search_by"]);
        }
      });

      onChange(locatedItems, selectedItems);
    });
  }

  @override
  Future moveItemsToPendingState({required Map selectedItems}) async {
    List items = selectedItems["items"].map((e) => e["id"]).toList();

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

    for (var element in items) {
      Query query = _objectBox.stockModelBox!
          .query(StockObjectBoxModel_.itemId.equals(element))
          .build();
      StockObjectBoxModel stock = query.findFirst();
      await sl.get<Firestore>().modifyDocument(
          path: "stock_data",
          uid: stock.uid!,
          data: !kIsLinux
              ? {
                  "container id": selectedItems["container_text"],
                  "warehouse location":
                      selectedItems["warehouse_location_text"],
                }
              : {
                  "container id": {
                    "stringValue": selectedItems["container_text"],
                  },
                  "warehouse location": {
                    "stringValue": selectedItems["warehouse_location_text"],
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
      newValue: selectedItems["warehouse_location_text"],
      uid: warehouseLocations["uid"],
      updateField: "warehouse_locations",
    );

    await _addNewLocations(
      locations: containers["containers"],
      newValue: selectedItems["container_text"],
      uid: containers["uid"],
      updateField: "containers",
    );
    // await sl.get<Firestore>().modifyDocument(path: "stock_data", docRef: , data: data)
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
