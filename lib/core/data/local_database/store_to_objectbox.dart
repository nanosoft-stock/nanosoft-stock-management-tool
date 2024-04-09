import 'package:stock_management_tool/constants/constants.dart';
import 'package:stock_management_tool/core/data/local_database/models/category_model.dart';
import 'package:stock_management_tool/core/data/local_database/models/input_fields_model.dart';
import 'package:stock_management_tool/core/data/local_database/models/product_model.dart';
import 'package:stock_management_tool/injection_container.dart';
import 'package:stock_management_tool/objectbox.dart';
import 'package:stock_management_tool/services/firestore.dart';

class StoreToObjectbox {
  StoreToObjectbox(this._objectBox);

  final ObjectBox _objectBox;

  Future<void> fetchData({bool deletePrevious = false}) async {
    if (deletePrevious) {
      _objectBox.clearDatabase();
      await _objectBox.create();
    }

    await fetchCategories();
  }

  Future<void> fetchCategories() async {
    List categories =
        (await sl.get<Firestore>().getDocuments(path: "category_list", includeDocRef: true))
            .toList();

    if (kIsLinux) {
      categories =
          categories.map((element) => element.map((k, v) => MapEntry(k, v.values.first))).toList();
    }

    for (var element in categories) {
      _objectBox.addCategory(CategoryModel(category: element["category"], ref: element["docRef"]));
      await fetchFields(element["category"], element["docRef"]);
      await fetchProducts(element["category"], element["docRef"]);
    }

    // _objectBox.getInputFields().then((value) {
    //   value.forEach((element) {
    //     print(element);
    //   });
    // });
    //
    // _objectBox.getProducts().then((value) {
    //   value.forEach((element) {
    //     print(element);
    //   });
    // });
  }

  Future<void> fetchFields(String category, String ref) async {
    List items = await sl.get<Firestore>().getDocuments(path: "category_list/$ref/fields");

    if (kIsLinux) {
      items = items
          .map((element) => element
              .map((field, value) => MapEntry(field, value.values.first))
              .cast<String, dynamic>())
          .toList();

      for (var element in items) {
        if (element["items"] != null) {
          element["items"] = element["items"]["values"].map((e) => e["stringValue"]).toList();
        }
      }
    }

    items.sort(
        (a, b) => int.parse(a["order"].toString()).compareTo(int.parse(b["order"].toString())));

    for (var element in items) {
      element["category"] = category;
      _objectBox.addInputField(
        InputFieldsModel.fromJson(element),
      );
    }
  }

  Future<void> fetchProducts(String category, String ref) async {
    List items = await sl.get<Firestore>().getDocuments(path: "category_list/$ref/product_list");

    if (kIsLinux) {
      items = items
          .map((element) => element
              .map((field, value) => MapEntry(field, value.values.first))
              .cast<String, dynamic>())
          .toList();
    }

    for (var element in items) {
      element['category'] = category;
      _objectBox.addProduct(ProductModel.fromJson(element));
    }
  }
}
