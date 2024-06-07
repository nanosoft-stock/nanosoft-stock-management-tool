import 'dart:async';

import 'package:stock_management_tool/constants/constants.dart';
import 'package:stock_management_tool/core/data/local_database/models/category_objectbox_model.dart';
import 'package:stock_management_tool/core/data/local_database/models/container_id_objectbox_model.dart';
import 'package:stock_management_tool/core/data/local_database/models/input_fields_objectbox_model.dart';
import 'package:stock_management_tool/core/data/local_database/models/item_id_objectbox_model.dart';
import 'package:stock_management_tool/core/data/local_database/models/product_objectbox_model.dart';
import 'package:stock_management_tool/core/data/local_database/models/stock_location_history_objectbox_model.dart';
import 'package:stock_management_tool/core/data/local_database/models/stock_objectbox_model.dart';
import 'package:stock_management_tool/core/data/local_database/models/warehouse_location_id_objectbox_model.dart';
import 'package:stock_management_tool/injection_container.dart';
import 'package:stock_management_tool/objectbox.dart';
import 'package:stock_management_tool/objectbox.g.dart';
import 'package:stock_management_tool/services/firestore.dart';

class FetchDataForObjectbox {
  FetchDataForObjectbox(this._objectBox);

  final ObjectBox _objectBox;

  Future<void> fetchData({bool deletePrevious = false}) async {
    if (deletePrevious) {
      _objectBox.clearDatabase();
      await _objectBox.create();
    }

    await fetchCategories();
  }

  Future<void> fetchCategories() async {
    List categories = (await sl
            .get<Firestore>()
            .getDocuments(path: "category_list", includeUid: true))
        .toList();

    if (kIsLinux) {
      categories = categories
          .map((element) => element.map((k, v) => MapEntry(k, v.values.first)))
          .toList();
    }

    for (var element in categories) {
      _objectBox.addCategory(CategoryObjectBoxModel(
          category: element["category"], uid: element["uid"]));
      await fetchFields(element["category"], element["uid"]);
      await fetchProducts(element["category"], element["uid"]);
    }

    await fetchStocks();

    await fetchLocations();

    await fetchStockHistory();

    // _objectBox.getInputFields().forEach((element) {
    //   print(element.toJson());
    // });
    //
    // _objectBox.getProducts().forEach((element) {
    //   print(element.toJson());
    // });
    //
    // _objectBox.getStocks().forEach((element) {
    //   print(element.toJson());
    // });
    //
    // _objectBox.getItemIds().forEach((element) {
    //   print(element.toJson());
    // });
    //
    // _objectBox.getContainerIds().forEach((element) {
    //   print(element.toJson());
    // });
    //
    // _objectBox.getWarehouseLocationIds().forEach((element) {
    //   print(element.toJson());
    // });
  }

  Future<void> fetchFields(String category, String uid) async {
    if (!kIsLinux) {
      sl
          .get<Firestore>()
          .listenToDocumentChanges(path: "category_list/$uid/fields")
          .listen((snapshot) {
        List<Map<String, dynamic>> items = [];

        for (var element in snapshot.docChanges) {
          if (element.type.name == "added") {
            items.add({
              ...element.doc.data() as Map<String, dynamic>,
              "uid": element.doc.id,
            });
          } else if (element.type.name == "modified") {
          } else if (element.type.name == "removed") {}
        }

        items.sort((a, b) => int.parse(a["order"].toString())
            .compareTo(int.parse(b["order"].toString())));

        _objectBox.addInputFieldList(
          items
              .map((e) => InputFieldsObjectBoxModel.fromJson(
                  {...e, "category": category}))
              .toList(),
        );
      });
    } else {
      List items = await sl
          .get<Firestore>()
          .getDocuments(path: "category_list/$uid/fields", includeUid: true);

      if (kIsLinux) {
        items = items
            .map((element) => element
                .map((field, value) => MapEntry(field, value.values.first))
                .cast<String, dynamic>())
            .toList();

        for (var element in items) {
          if (element["items"] != null) {
            element["items"] = element["items"]["values"]
                .map((e) => e["stringValue"])
                .toList();
          }
        }
      }

      items.sort((a, b) => int.parse(a["order"].toString())
          .compareTo(int.parse(b["order"].toString())));

      _objectBox.addInputFieldList(
        items
            .map((e) => InputFieldsObjectBoxModel.fromJson(
                {...e, "category": category}))
            .toList(),
      );
    }
  }

  Future<void> fetchProducts(String category, String uid) async {
    if (!kIsLinux) {
      sl
          .get<Firestore>()
          .listenToDocumentChanges(path: "category_list/$uid/product_list")
          .listen((snapshot) {
        List<Map<String, dynamic>> items = [];

        for (var element in snapshot.docChanges) {
          if (element.type.name == "added") {
            items.add({
              ...element.doc.data() as Map<String, dynamic>,
              "uid": element.doc.id,
            });
          } else if (element.type.name == "modified") {
          } else if (element.type.name == "removed") {}
        }

        _objectBox.addProductList(
          items
              .map((e) =>
                  ProductObjectBoxModel.fromJson({...e, "category": category}))
              .toList(),
        );
      });
    } else {
      List items = await sl.get<Firestore>().getDocuments(
            path: "category_list/$uid/product_list",
            includeUid: true,
          );

      items = items
          .map((element) => element
              .map((field, value) => MapEntry(field, value.values.first))
              .cast<String, dynamic>())
          .toList();

      _objectBox.addProductList(items
          .map((e) =>
              ProductObjectBoxModel.fromJson({...e, "category": category}))
          .toList());
    }
  }

  Future<void> fetchStocks() async {
    if (!kIsLinux) {
      sl
          .get<Firestore>()
          .listenToDocumentChanges(path: "stock_data")
          .listen((snapshot) {
        List addStock = [];
        List modifyStock = [];
        List removeStock = [];

        for (var element in snapshot.docChanges) {
          if (element.type.name == "added") {
            addStock.add(StockObjectBoxModel.fromJson({
              ...element.doc.data() as Map<String, dynamic>,
              "uid": element.doc.id,
            }));
            // _objectBox.addStock(StockObjectBoxModel.fromJson({
            //   ...element.doc.data() as Map<String, dynamic>,
            //   "uid": element.doc.id,
            // }));
          } else if (element.type.name == "modified") {
            Query query = _objectBox.stockModelBox!
                .query(StockObjectBoxModel_.uid.equals(element.doc.id))
                .build();
            StockObjectBoxModel stock = query.findFirst();
            query.close();

            int id = stock.id;
            stock = StockObjectBoxModel.fromJson({
              ...element.doc.data() as Map<String, dynamic>,
              "uid": element.doc.id,
            });
            stock.id = id;

            modifyStock.add(stock);

            // _objectBox.addStock(stock);
          } else if (element.type.name == "removed") {
            Query query = _objectBox.stockModelBox!
                .query(StockObjectBoxModel_.uid.equals(element.doc.id))
                .build();
            StockObjectBoxModel stock = query.findFirst();
            query.close();

            removeStock.add(stock.id);

            // _objectBox.removeStock(stock.id);
          }
        }

        _objectBox.addStockList(addStock.cast<StockObjectBoxModel>());
        _objectBox.addStockList(modifyStock.cast<StockObjectBoxModel>());
        _objectBox.removeStockList(removeStock.cast<int>());
      });
    } else {
      List items = await sl.get<Firestore>().getDocuments(
            path: "stock_data",
            includeUid: true,
          );

      items = items
          .map((element) => element
              .map((field, value) => MapEntry(field, value.values.first))
              .cast<String, dynamic>())
          .toList();

      items.sort((a, b) => a["date"].compareTo(b["date"]));

      _objectBox.addStockList(
        items.map((e) => StockObjectBoxModel.fromJson(e)).toList(),
      );
    }
  }

  Future<void> fetchLocations() async {
    if (!kIsLinux) {
      sl
          .get<Firestore>()
          .listenToDocumentChanges(path: "all_locations")
          .listen((snapshot) {
        for (var element in snapshot.docChanges) {
          if (element.type.name == "added") {
            Map data = element.doc.data() as Map<String, dynamic>;

            if (data.containsKey("items")) {
              _objectBox.addItemIdList(data["items"]
                  .map((e) => ItemIdObjectBoxModel.fromJson({"item_id": e}))
                  .toList()
                  .cast<ItemIdObjectBoxModel>());
            } else if (data.containsKey("containers")) {
              _objectBox.addContainerIdList(data["containers"]
                  .map((e) =>
                      ContainerIdObjectBoxModel.fromJson({"container_id": e}))
                  .toList()
                  .cast<ContainerIdObjectBoxModel>());
            } else if (data.containsKey("warehouse_locations")) {
              _objectBox.addWarehouseLocationIdList(data["warehouse_locations"]
                  .map((e) => WarehouseLocationIdObjectBoxModel.fromJson(
                      {"warehouse_location_id": e}))
                  .toList()
                  .cast<WarehouseLocationIdObjectBoxModel>());
            }
          } else if (element.type.name == "modified") {
            Map data = element.doc.data() as Map<String, dynamic>;

            if (data.containsKey("items")) {
              List localItems =
                  _objectBox.getItemIds().map((e) => e.itemId).toList();
              List cloudItems = data["items"];

              for (var element in localItems) {
                if (!cloudItems.contains(element)) {
                  Query query = _objectBox.itemIdBox!
                      .query(ItemIdObjectBoxModel_.itemId.equals(element))
                      .build();
                  ItemIdObjectBoxModel item = query.findFirst();
                  query.close();

                  _objectBox.removeItem(item.id);
                }
              }

              for (var element in cloudItems) {
                if (!localItems.contains(element)) {
                  _objectBox.addItemId(
                      ItemIdObjectBoxModel.fromJson({"item_id": element}));
                }
              }

              // _objectBox.itemIdBox!.removeAll();
              //
              // _objectBox.addItemIdList(data["items"]
              //     .map((e) => ItemIdObjectBoxModel.fromJson({"item_id": e}))
              //     .toList()
              //     .cast<ItemIdObjectBoxModel>());
            } else if (data.containsKey("containers")) {
              List localContainers = _objectBox
                  .getContainerIds()
                  .map((e) => e.containerId)
                  .toList();
              List cloudContainers = data["containers"];

              for (var element in localContainers) {
                if (!cloudContainers.contains(element)) {
                  Query query = _objectBox.containerIdBox!
                      .query(ContainerIdObjectBoxModel_.containerId
                          .equals(element))
                      .build();
                  ContainerIdObjectBoxModel container = query.findFirst();
                  query.close();

                  _objectBox.removeContainer(container.id);
                }
              }

              for (var element in cloudContainers) {
                if (!localContainers.contains(element)) {
                  _objectBox.addContainerId(ContainerIdObjectBoxModel.fromJson(
                      {"container_id": element}));
                }
              }

              // _objectBox.containerIdBox!.removeAll();
              //
              // _objectBox.addContainerIdList(data["containers"]
              //     .map((e) =>
              //         ContainerIdObjectBoxModel.fromJson({"container_id": e}))
              //     .toList()
              //     .cast<ContainerIdObjectBoxModel>());
            } else if (data.containsKey("warehouse_locations")) {
              List localWarehouseLocations =
                  _objectBox.getItemIds().map((e) => e.itemId).toList();
              List cloudWarehouseLocations = data["warehouse_locations"];

              for (var element in localWarehouseLocations) {
                if (!cloudWarehouseLocations.contains(element)) {
                  Query query = _objectBox.warehouseLocationIdBox!
                      .query(WarehouseLocationIdObjectBoxModel_
                          .warehouseLocationId
                          .equals(element))
                      .build();
                  WarehouseLocationIdObjectBoxModel warehouseLocation =
                      query.findFirst();
                  query.close();

                  _objectBox.removeWarehouseLocation(warehouseLocation.id);
                }
              }

              for (var element in cloudWarehouseLocations) {
                if (!localWarehouseLocations.contains(element)) {
                  _objectBox.addWarehouseLocationId(
                      WarehouseLocationIdObjectBoxModel.fromJson(
                          {"warehouse_location_id": element}));
                }
              }

              //   _objectBox.warehouseLocationIdBox!.removeAll();
              //
              //   _objectBox.addWarehouseLocationIdList(data["warehouse_locations"]
              //       .map((e) => WarehouseLocationIdObjectBoxModel.fromJson(
              //           {"warehouse_location_id": e}))
              //       .toList()
              //       .cast<WarehouseLocationIdObjectBoxModel>());
            }
          } else if (element.type.name == "removed") {}
        }
      });
    } else {
      List items =
          await sl.get<Firestore>().getDocuments(path: "all_locations");

      items = items
          .map((element) => element
              .map((field, value) => MapEntry(field, value.values.first))
              .cast<String, dynamic>())
          .toList();

      for (var element in items) {
        if (element.containsKey("items")) {
          _objectBox.addItemIdList(element["items"]
              .map((e) => ItemIdObjectBoxModel.fromJson({"item_id": e}))
              .toList()
              .cast<ItemIdObjectBoxModel>());
        } else if (element.containsKey("containers")) {
          _objectBox.addContainerIdList(element["containers"]
              .map((e) =>
                  ContainerIdObjectBoxModel.fromJson({"container_id": e}))
              .toList()
              .cast<ContainerIdObjectBoxModel>());
        } else if (element.containsKey("warehouse_locations")) {
          _objectBox.addWarehouseLocationIdList(element["warehouse_locations"]
              .map((e) => WarehouseLocationIdObjectBoxModel.fromJson(
                  {"warehouse_location_id": e}))
              .toList()
              .cast<WarehouseLocationIdObjectBoxModel>());
        }
      }
    }
  }

  Future<void> fetchStockHistory() async {
    if (!kIsLinux) {
      sl
          .get<Firestore>()
          .listenToDocumentChanges(
            path: "stock_location_history",
          )
          .listen((snapshot) {
        List addHistory = [];
        List modifyHistory = [];
        List removeHistory = [];

        for (var element in snapshot.docChanges) {
          if (element.type.name == "added") {
            addHistory.add(StockLocationHistoryObjectBoxModel.fromJson({
              ...element.doc.data() as Map<String, dynamic>,
              "uid": element.doc.id,
            }));

            // _objectBox.addStockLocationHistory(
            //     StockLocationHistoryObjectBoxModel.fromJson({
            //   ...element.doc.data() as Map<String, dynamic>,
            //   "uid": element.doc.id,
            // }));
          } else if (element.type.name == "modified") {
            Query query = _objectBox.stockLocationHistoryModelBox!
                .query(StockLocationHistoryObjectBoxModel_.uid
                    .equals(element.doc.id))
                .build();
            StockLocationHistoryObjectBoxModel history = query.findFirst();
            query.close();

            int id = history.id;
            history = StockLocationHistoryObjectBoxModel.fromJson({
              ...element.doc.data() as Map<String, dynamic>,
              "uid": element.doc.id,
            });
            history.id = id;

            modifyHistory.add(history);

            // _objectBox.addStockLocationHistory(history);
          } else if (element.type.name == "removed") {
            Query query = _objectBox.stockLocationHistoryModelBox!
                .query(StockLocationHistoryObjectBoxModel_.uid
                    .equals(element.doc.id))
                .build();
            StockLocationHistoryObjectBoxModel history = query.findFirst();
            query.close();

            removeHistory.add(history.id);

            // _objectBox.removeStockLocationHistory(history.id);
          }
        }

        _objectBox.addStockLocationHistoryList(
            addHistory.cast<StockLocationHistoryObjectBoxModel>());
        _objectBox.addStockLocationHistoryList(
            modifyHistory.cast<StockLocationHistoryObjectBoxModel>());
        _objectBox.removeStockLocationHistoryList(removeHistory.cast<int>());
      });
    } else {
      List items = await sl.get<Firestore>().getDocuments(
            path: "stock_location_history",
            includeUid: true,
          );

      items = items
          .map((element) => element
              .map((field, value) => MapEntry(field, value.values.first))
              .cast<String, dynamic>())
          .toList();

      items.sort((a, b) => a["date"].compareTo(b["date"]));

      _objectBox.addStockLocationHistoryList(
        items
            .map((e) => StockLocationHistoryObjectBoxModel.fromJson(e))
            .toList(),
      );
    }
  }
}
