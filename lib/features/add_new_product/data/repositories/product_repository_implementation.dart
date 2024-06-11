import 'package:stock_management_tool/core/helper/add_new_product_helper.dart';
import 'package:stock_management_tool/core/helper/string_casting_extension.dart';
import 'package:stock_management_tool/core/services/firestore.dart';
import 'package:stock_management_tool/features/add_new_product/data/models/product_input_field_model.dart';
import 'package:stock_management_tool/features/add_new_product/domain/repositories/product_repository.dart';
import 'package:stock_management_tool/injection_container.dart';
import 'package:stock_management_tool/objectbox.dart';

class ProductRepositoryImplementation implements ProductRepository {
  final ObjectBox _objectBox = sl.get<ObjectBox>();

  @override
  Future<List<ProductInputFieldModel>> getInitialInputFields() async {
    return [
      {
        "uid": "",
        "field": "category",
        "datatype": "string",
        "isWithSKU": true,
        "isTitleCase": true,
        "items": _objectBox
            .getCategories()
            .map((e) => e.category!.toTitleCase())
            .toList(),
      },
      {
        "uid": "",
        "field": "sku",
        "datatype": "string",
        "isWithSKU": true,
        "isTitleCase": false,
      },
    ].map((e) => ProductInputFieldModel.fromJson(e)).toList();
  }

  @override
  Future<List<ProductInputFieldModel>> getCategoryBasedInputFields(
      {required String category}) async {
    List fields = _objectBox
        .getInputFields()
        .where((element) =>
            element.isWithSKU! &&
            element.category == category.toLowerCase() &&
            !["category", "sku"].contains(element.field))
        .map((e) => e.toJson())
        .toList();

    return fields.map((e) => ProductInputFieldModel.fromJson(e)).toList();
  }

  @override
  Future addNewProduct({required List fields}) async {
    Map data = {};
    for (var element in fields) {
      data[element.field] = element.textValue;
    }

    String ref = _objectBox
        .getCategories()
        .where((element) => element.category == data["category"].toLowerCase())
        .first
        .uid!;

    await sl.get<Firestore>().createDocument(
          path: "category_list/$ref/product_list",
          data: AddNewProductHelper.toJson(
            category: fields[0].textValue.toLowerCase(),
            data: data,
          ),
        );
  }
}
