import 'package:stock_management_tool/features/add_new_product/data/models/product_input_field_model.dart';
import 'package:stock_management_tool/features/add_new_product/domain/repositories/product_repository.dart';
import 'package:stock_management_tool/helper/add_new_product_helper.dart';
import 'package:stock_management_tool/helper/string_casting_extension.dart';
import 'package:stock_management_tool/models/all_predefined_data.dart';
import 'package:stock_management_tool/services/firestore.dart';

class ProductRepositoryImplementation implements ProductRepository {
  @override
  Future<List<ProductInputFieldModel>> getInitialInputFields() async {
    return [
      {
        "field": "category",
        "datatype": "string",
        "isWithSKU": true,
        "isTitleCase": true,
        "items": AllPredefinedData.data["categories"]
            .map(
              (e) => e.toString().toTitleCase(),
            )
            .toList()
      },
      {
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
    List fields = AllPredefinedData.data[category.toLowerCase()]["fields"]
        .where((element) => element["isWithSKU"] && !["category", "sku"].contains(element["field"]))
        .toList();
    return fields.map((e) => ProductInputFieldModel.fromJson(e)).toList();
  }

  @override
  Future addNewProduct({required List fields}) async {
    Map data = {};
    for (var element in fields) {
      data[element.field] = element.textValue;
    }
    await Firestore().createDocument(
      path:
          "category_list/${AllPredefinedData.data[fields[0].textValue.toLowerCase()]["categoryDoc"]}/product_list",
      data: AddNewProductHelper.toJson(
        category: fields[0].textValue.toLowerCase(),
        data: data,
      ),
    );
  }
}
