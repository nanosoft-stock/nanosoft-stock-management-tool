import 'package:stock_management_tool/core/constants/constants.dart';
import 'package:stock_management_tool/core/helper/add_new_product_helper.dart';
import 'package:stock_management_tool/core/helper/case_helper.dart';
import 'package:stock_management_tool/core/local_database/local_database.dart';
import 'package:stock_management_tool/core/services/firestore.dart';
import 'package:stock_management_tool/core/services/injection_container.dart';
import 'package:stock_management_tool/features/add_new_product/data/models/product_input_field_model.dart';
import 'package:stock_management_tool/features/add_new_product/domain/repositories/product_repository.dart';

class ProductRepositoryImplementation implements ProductRepository {
  ProductRepositoryImplementation(this._localDB);

  final LocalDatabase _localDB;

  @override
  void listenToCloudDataChange(
      {required List fields, required Function(List) onChange}) {
    _localDB.categoryStream().listen((snapshot) {
      Map categoryMap = fields.firstWhere((ele) => ele["field"] == "category");

      categoryMap["items"] = _localDB.categories
          .map((e) => e.category!)
          .toList()
        ..sort((a, b) => a.compareTo(b));

      onChange(fields);
    });

    // _objectBox.getInputFieldStream().listen((snapshot) async {
    //   String category =
    //       fields.firstWhere((ele) => ele["field"] == "category")["text_value"];

    //   if (_objectBox
    //       .getCategories()
    //       .any((e) => e.category?.toLowerCase() == category.toLowerCase())) {
    //     List newFields = _objectBox
    //         .getInputFields()
    //         .where((e) =>
    //             !e.isBackground! &&
    //             e.category?.toLowerCase() == category.toLowerCase() &&
    //             !["category", "sku"].contains(e.field))
    //         .map((e) => ProductInputFieldModel.fromJson({
    //               ...e.toJson(),
    //               "text_value": fields.firstWhere(
    //                   (ele) => ele["field"] == e.field,
    //                   orElse: () => <String, dynamic>{})["text_value"],
    //             }).toJson())
    //         .toList();

    //     newFields.sort((a, b) => a["order"].compareTo(b["order"]));
    //     fields.removeWhere((e) => !["category", "sku"].contains(e.field));
    //     fields.addAll(newFields);

    //     onChange(fields);
    //   }
    // });

    // _objectBox.getCategoryStream().listen((snapshot) {
    //   if (snapshot.isNotEmpty) {
    //     Map categoryMap =
    //         fields.firstWhere((ele) => ele["field"] == "category");
    //     categoryMap["items"] = _objectBox
    //         .getCategories()
    //         .map((e) => e.category!)
    //         .toList()
    //       ..sort((a, b) => a.compareTo(b));
    //   }

    //   onChange(fields);
    // });
  }

  @override
  List<Map<String, dynamic>> getInitialInputFields() {
    return [
      {
        "field": "category",
        "datatype": "string",
        "items": _localDB.categories.map((e) => e.category!).toList()
          ..sort((a, b) => a.compareTo(b)),
        "name_case": "title",
        "value_case": "none",
        "order": 2,
      },
      {
        "field": "sku",
        "datatype": "string",
        "name_case": "upper",
        "value_case": "upper",
        "order": 3,
      },
    ].map((e) => ProductInputFieldModel.fromJson(e).toJson()).toList();
  }

  @override
  List<Map<String, dynamic>> getCategoryBasedInputFields(
      {required String category, required String sku}) {
    List fields = _localDB.categoryFields
        .where((element) =>
            element.inSku! &&
            element.category?.toLowerCase() == category.toLowerCase())
        .map((e) {
      if (e.field == "category") {
        return {
          ...e.toMap(),
          "items": _localDB.categories.map((e) => e.category!).toList()
            ..sort((a, b) => a.compareTo(b)),
          "text_value": category,
        };
      } else if (e.field == "sku") {
        return {
          ...e.toMap(),
          "text_value": sku,
        };
      }
      return e.toMap();
    }).toList();

    fields.sort((a, b) => a["order"].compareTo(b["order"]));

    return fields
        .map((e) => ProductInputFieldModel.fromJson(e).toJson())
        .toList();
  }

  @override
  Future<void> addNewProduct({required List fields}) async {
    Map data = {};
    for (var element in fields) {
      data[element["field"]] =
          CaseHelper.convert(element["value_case"], element["text_value"]);
    }

    await sl.get<Firestore>().createDocument(
        path: "skus", data: AddNewProductHelper.toJson(data: data));

    await _addNewFieldItems(data: data);
  }

  Future<void> _addNewFieldItems({required Map data}) async {
    List fields = _localDB.categoryFields
        .where((e) =>
            e.category == data["category"] &&
            e.inSku == true &&
            // e.items != null &&
            !["category", "sku"].contains(e.field))
        .map((e) => e.toJson())
        .toList();

    for (var field in fields) {
      String value = data[field["field"]];

      if (value != "" && !field["items"].contains(value)) {
        List items = (field["items"].toSet()..add(data[field["field"]]))
            .toList()
          ..sort((a, b) => a.toString().compareTo(b.toString()));

        await sl.get<Firestore>().modifyDocument(
              path: "category_fields",
              uid: field["uid"],
              updateMask: ["items"],
              data: !kIsLinux
                  ? {
                      "items": items,
                    }
                  : {
                      "items": {
                        "arrayValue": {
                          "values":
                              items.map((e) => {"stringValue": e}).toList(),
                        }
                      }
                    },
            );
      }
    }
  }
}
