import 'dart:async';

import 'package:stock_management_tool/constants/constants.dart';
import 'package:stock_management_tool/core/data/local_database/models/category_objectbox_model.dart';
import 'package:stock_management_tool/core/data/local_database/models/input_fields_objectbox_model.dart';
import 'package:stock_management_tool/core/data/local_database/models/product_objectbox_model.dart';
import 'package:stock_management_tool/core/data/local_database/models/stock_objectbox_model.dart';
import 'package:stock_management_tool/injection_container.dart';
import 'package:stock_management_tool/objectbox.dart';
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
            .getDocuments(path: "category_list", includeDocRef: true))
        .toList();

    if (kIsLinux) {
      categories = categories
          .map((element) => element.map((k, v) => MapEntry(k, v.values.first)))
          .toList();
    }

    for (var element in categories) {
      _objectBox.addCategory(CategoryObjectBoxModel(
          category: element["category"], ref: element["docRef"]));
      await fetchFields(element["category"], element["docRef"]);
      await fetchProducts(element["category"], element["docRef"]);
    }

    await fetchStocks();

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
  }

  Future<void> fetchFields(String category, String ref) async {
    if (!kIsLinux) {
      sl
          .get<Firestore>()
          .listenToDocumentChanges(path: "category_list/$ref/fields")
          .listen((snapshot) {
        List<Map<String, dynamic>> items = [];

        for (var element in snapshot.docChanges) {
          if (element.type.name == "added") {
            items.add(element.doc.data() as Map<String, dynamic>);
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
          .getDocuments(path: "category_list/$ref/fields");

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

  Future<void> fetchProducts(String category, String ref) async {
    if (!kIsLinux) {
      sl
          .get<Firestore>()
          .listenToDocumentChanges(path: "category_list/$ref/product_list")
          .listen((snapshot) {
        List<Map<String, dynamic>> items = [];

        for (var element in snapshot.docChanges) {
          if (element.type.name == "added") {
            items.add(element.doc.data() as Map<String, dynamic>);
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
      List items = await sl
          .get<Firestore>()
          .getDocuments(path: "category_list/$ref/product_list");

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
        List<Map<String, dynamic>> items = [];
        for (var element in snapshot.docChanges) {
          if (element.type.name == "added") {
            items.add(element.doc.data() as Map<String, dynamic>);
          } else if (element.type.name == "modified") {
          } else if (element.type.name == "removed") {
            print(element.doc.data());
          }
        }

        items.sort((a, b) => a["date"].compareTo(b["date"]));

        _objectBox.addStockList(
          items.map((e) => StockObjectBoxModel.fromJson(e)).toList(),
        );
      });
    } else {
      List items = await sl.get<Firestore>().getDocuments(path: "stock_data");

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
}
