import 'dart:async';

import 'package:stock_management_tool/core/constants/constants.dart';
import 'package:stock_management_tool/core/data/local_database/models/category_objectbox_model.dart';
import 'package:stock_management_tool/core/data/local_database/models/container_id_objectbox_model.dart';
import 'package:stock_management_tool/core/data/local_database/models/input_fields_objectbox_model.dart';
import 'package:stock_management_tool/core/data/local_database/models/item_id_objectbox_model.dart';
import 'package:stock_management_tool/core/data/local_database/models/stock_location_history_objectbox_model.dart';
import 'package:stock_management_tool/core/data/local_database/models/stock_objectbox_model.dart';
import 'package:stock_management_tool/core/data/local_database/models/warehouse_location_id_objectbox_model.dart';
import 'package:stock_management_tool/core/services/firestore.dart';
import 'package:stock_management_tool/injection_container.dart';
import 'package:stock_management_tool/objectbox.dart';
import 'package:stock_management_tool/objectbox.g.dart';

class FetchDataForObjectbox {
  FetchDataForObjectbox(this._objectBox);

  final ObjectBox _objectBox;

  Future<void> fetchData({bool deletePrevious = false}) async {
    if (deletePrevious) {
      _objectBox.clearDatabase();
      await _objectBox.create();
    }

    await fetchCategoriesAndLocations();

    await fetchFields();

    await fetchStocks();

    await fetchStockHistory();
  }

  Future<void> fetchCategoriesAndLocations() async {
    if (!kIsLinux) {
      sl
          .get<Firestore>()
          .listenToDocumentChanges(path: "unique_values")
          .listen((snapshot) {
        for (var element in snapshot.docChanges) {
          if (element.type.name == "added" || element.type.name == "modified") {
            Map<String, dynamic> data =
                element.doc.data() as Map<String, dynamic>;

            if (data.containsKey("category")) {
              categoryIdUid = element.doc.id;
              _objectBox.categoryModelBox?.removeAll();
              List categories = [];

              data["category"]?.forEach((k, v) {
                categories.add(CategoryObjectBoxModel.fromJson({
                  "category": k,
                  "skus": v["sku"]
                      .entries
                      .map((e) => {e.key: e.value})
                      .toList()
                      .cast<Map<String, dynamic>>(),
                }));
              });

              _objectBox
                  .addCategoryList(categories.cast<CategoryObjectBoxModel>());
            } else if (data.containsKey("item_id")) {
              itemIdUid = element.doc.id;
              _objectBox.itemIdBox?.removeAll();
              List items = [];

              data["item_id"]?.forEach((k, v) {
                items.add(ItemIdObjectBoxModel.fromJson({
                  "item_id": k,
                  "container_id": v["container_id"],
                  "doc_ref": v["doc_ref"],
                  "status": v["status"],
                }));
              });

              _objectBox.addItemIdList(items.cast<ItemIdObjectBoxModel>());
            } else if (data.containsKey("container_id")) {
              containerIdUid = element.doc.id;
              _objectBox.containerIdBox?.removeAll();
              List containers = [];

              data["container_id"]?.forEach((k, v) {
                containers.add(ContainerIdObjectBoxModel.fromJson({
                  "container_id": k,
                  "status": v["status"],
                  "warehouse_location_id": v["warehouse_location_id"],
                }));
              });

              _objectBox.addContainerIdList(
                  containers.cast<ContainerIdObjectBoxModel>());
            } else if (data.containsKey("warehouse_location_id")) {
              warehouseLocationIdUid = element.doc.id;
              _objectBox.warehouseLocationIdBox?.removeAll();
              List warehouseLocations = [];

              data["warehouse_location_id"]?.forEach((k, _) {
                warehouseLocations
                    .add(WarehouseLocationIdObjectBoxModel.fromJson({
                  "warehouse_location_id": k,
                }));
              });
              _objectBox.addWarehouseLocationIdList(
                  warehouseLocations.cast<WarehouseLocationIdObjectBoxModel>());
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

  Future<void> fetchFields() async {
    if (!kIsLinux) {
      sl
          .get<Firestore>()
          .listenToDocumentChanges(path: "category_fields")
          .listen((snapshot) {
        List fields = [];

        for (var element in snapshot.docChanges) {
          if (element.type.name == "added") {
            fields.add(InputFieldsObjectBoxModel.fromJson({
              "uid": element.doc.id,
              ...element.doc.data() as Map<String, dynamic>,
            }));
          } else if (element.type.name == "modified") {
          } else if (element.type.name == "removed") {}
        }

        fields.sort((a, b) => a.order.compareTo(b.order));

        _objectBox.addInputFieldList(
          fields.cast<InputFieldsObjectBoxModel>(),
        );
      });
    } else {
      List items = await sl
          .get<Firestore>()
          .getDocuments(path: "category_fields", includeUid: true);

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
        items.map((e) => InputFieldsObjectBoxModel.fromJson(e)).toList(),
      );
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
          } else if (element.type.name == "removed") {
            Query query = _objectBox.stockModelBox!
                .query(StockObjectBoxModel_.uid.equals(element.doc.id))
                .build();
            StockObjectBoxModel stock = query.findFirst();
            query.close();

            removeStock.add(stock.id);
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
          } else if (element.type.name == "removed") {
            Query query = _objectBox.stockLocationHistoryModelBox!
                .query(StockLocationHistoryObjectBoxModel_.uid
                    .equals(element.doc.id))
                .build();
            StockLocationHistoryObjectBoxModel history = query.findFirst();
            query.close();

            removeHistory.add(history.id);
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
