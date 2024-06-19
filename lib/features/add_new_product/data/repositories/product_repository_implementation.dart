import 'package:stock_management_tool/core/helper/add_new_product_helper.dart';
import 'package:stock_management_tool/core/helper/case_helper.dart';
import 'package:stock_management_tool/core/services/firestore.dart';
import 'package:stock_management_tool/features/add_new_product/data/models/product_input_field_model.dart';
import 'package:stock_management_tool/features/add_new_product/domain/repositories/product_repository.dart';
import 'package:stock_management_tool/injection_container.dart';
import 'package:stock_management_tool/objectbox.dart';

class ProductRepositoryImplementation implements ProductRepository {
  final ObjectBox _objectBox = sl.get<ObjectBox>();

  @override
  List<Map<String, dynamic>> getInitialInputFields() {
    return [
      {
        "field": "category",
        "datatype": "string",
        "items": _objectBox.getCategories().map((e) => e.category!).toList()
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
    List fields = _objectBox
        .getInputFields()
        .where((element) =>
            element.inSku! &&
            element.category?.toLowerCase() == category.toLowerCase())
        .map((e) {
      if (e.field == "category") {
        return {
          ...e.toJson(),
          "items": _objectBox.getCategories().map((e) => e.category!).toList()
            ..sort((a, b) => a.compareTo(b)),
          "text_value": category,
        };
      } else if (e.field == "sku") {
        return {
          ...e.toJson(),
          "text_value": sku,
        };
      }
      return e.toJson();
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
  }
}
