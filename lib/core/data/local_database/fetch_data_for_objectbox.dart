import 'dart:async';

import 'package:stock_management_tool/core/constants/constants.dart';
import 'package:stock_management_tool/core/data/local_database/models/category_objectbox_model.dart';
import 'package:stock_management_tool/core/data/local_database/models/container_id_objectbox_model.dart';
import 'package:stock_management_tool/core/data/local_database/models/input_fields_objectbox_model.dart';
import 'package:stock_management_tool/core/data/local_database/models/item_id_objectbox_model.dart';
import 'package:stock_management_tool/core/data/local_database/models/product_objectbox_model.dart';
import 'package:stock_management_tool/core/data/local_database/models/stock_location_history_objectbox_model.dart';
import 'package:stock_management_tool/core/data/local_database/models/stock_objectbox_model.dart';
import 'package:stock_management_tool/core/data/local_database/models/warehouse_location_id_objectbox_model.dart';
import 'package:stock_management_tool/core/services/firestore.dart';
import 'package:stock_management_tool/core/services/injection_container.dart';
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
    await fetchProducts();
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
    } else {}
  }

  Future<void> fetchFields() async {
    if (!kIsLinux) {
      sl
          .get<Firestore>()
          .listenToDocumentChanges(path: "category_fields")
          .listen((snapshot) {
        List addFields = [];
        List modifyFields = [];
        List removeFields = [];

        for (var element in snapshot.docChanges) {
          Map<String, dynamic> data =
              element.doc.data() as Map<String, dynamic>;

          if (element.type.name == "added") {
            addFields.add(InputFieldsObjectBoxModel.fromJson({
              "uid": element.doc.id,
              ...data,
            }));
          } else if (element.type.name == "modified") {
            Query query = _objectBox.inputFieldsBox!
                .query(InputFieldsObjectBoxModel_.uid.equals(element.doc.id))
                .build();
            InputFieldsObjectBoxModel field = query.findFirst();
            query.close();

            int id = field.id;
            field = InputFieldsObjectBoxModel.fromJson({
              "uid": element.doc.id,
              ...data,
            });
            field.id = id;

            modifyFields.add(field);
          } else if (element.type.name == "removed") {
            Query query = _objectBox.inputFieldsBox!
                .query(InputFieldsObjectBoxModel_.uid.equals(element.doc.id))
                .build();
            InputFieldsObjectBoxModel field = query.findFirst();
            query.close();

            removeFields.add(field.id);
          }
        }

        _objectBox
            .addInputFieldList(addFields.cast<InputFieldsObjectBoxModel>());
        _objectBox
            .addInputFieldList(modifyFields.cast<InputFieldsObjectBoxModel>());
        _objectBox.removeInputFieldsList(removeFields.cast<int>());
      });
    } else {}
  }

  Future<void> fetchProducts() async {
    if (!kIsLinux) {
      sl
          .get<Firestore>()
          .listenToDocumentChanges(path: "skus")
          .listen((snapshot) {
        List addProducts = [];
        List modifyProducts = [];
        List removeProducts = [];

        for (var element in snapshot.docChanges) {
          Map<String, dynamic> data =
              element.doc.data() as Map<String, dynamic>;

          String category = data["category"];
          String sku = data["sku"];

          if (element.type.name == "added") {
            data
              ..remove("category")
              ..remove("sku");
            List fields = data.keys.toList();
            List values = data.values.toList().cast<String>();

            addProducts.add(ProductObjectBoxModel.fromJson({
              "uid": element.doc.id,
              "category": category,
              "sku": sku,
              "fields": fields,
              "values": values,
            }));
          } else if (element.type.name == "modified") {
            Query query = _objectBox.productModelBox!
                .query(ProductObjectBoxModel_.uid.equals(element.doc.id))
                .build();
            ProductObjectBoxModel product = query.findFirst();
            query.close();

            data
              ..remove("category")
              ..remove("sku");
            List fields = data.keys.toList();
            List values = data.values.toList().cast<String>();

            int id = product.id;
            product = ProductObjectBoxModel.fromJson({
              "uid": element.doc.id,
              "category": category,
              "sku": sku,
              "fields": fields,
              "values": values,
            });
            product.id = id;

            modifyProducts.add(product);
          } else if (element.type.name == "removed") {
            Query query = _objectBox.productModelBox!
                .query(ProductObjectBoxModel_.uid.equals(element.doc.id))
                .build();
            ProductObjectBoxModel product = query.findFirst();
            query.close();

            removeProducts.add(product.id);
          }
        }

        _objectBox.addProductList(addProducts.cast<ProductObjectBoxModel>());
        _objectBox.addProductList(modifyProducts.cast<ProductObjectBoxModel>());
        _objectBox.removeProductsList(removeProducts.cast<int>());
      });
    } else {}
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
          Map<String, dynamic> data =
              element.doc.data() as Map<String, dynamic>;

          var date = data["date"];
          String category = data["category"];
          String itemId = data["item id"];
          String containerId = data["container id"];
          String warehouseLocationId = data["warehouse location id"];

          if (element.type.name == "added") {
            data
              ..remove("date")
              ..remove("category")
              ..remove("item id")
              ..remove("container id")
              ..remove("warehouse location id");

            List fields = data.keys.toList();
            List values = data.values.toList().cast<String>();

            addStock.add(StockObjectBoxModel.fromJson({
              "uid": element.doc.id,
              "date": date,
              "category": category,
              "item id": itemId,
              "container id": containerId,
              "warehouse location id": warehouseLocationId,
              "fields": fields,
              "values": values,
            }));
          } else if (element.type.name == "modified") {
            Query query = _objectBox.stockModelBox!
                .query(StockObjectBoxModel_.uid.equals(element.doc.id))
                .build();
            StockObjectBoxModel stock = query.findFirst();
            query.close();

            int id = stock.id;

            data
              ..remove("date")
              ..remove("category")
              ..remove("item id")
              ..remove("container id")
              ..remove("warehouse location id");

            List fields = data.keys.toList();
            List values = data.values.toList().cast<String>();

            stock = StockObjectBoxModel.fromJson({
              "uid": element.doc.id,
              "date": date,
              "category": category,
              "item id": itemId,
              "container id": containerId,
              "warehouse location id": warehouseLocationId,
              "fields": fields,
              "values": values,
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
    } else {}
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
              "uid": element.doc.id,
              ...element.doc.data() as Map<String, dynamic>,
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
              "uid": element.doc.id,
              ...element.doc.data() as Map<String, dynamic>,
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
    } else {}
  }
}
