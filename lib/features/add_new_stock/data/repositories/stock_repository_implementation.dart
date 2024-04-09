import 'package:stock_management_tool/features/add_new_stock/data/models/stock_input_field_model.dart';
import 'package:stock_management_tool/features/add_new_stock/domain/repositories/stock_repository.dart';
import 'package:stock_management_tool/helper/add_new_stock_helper.dart';
import 'package:stock_management_tool/helper/string_casting_extension.dart';
import 'package:stock_management_tool/injection_container.dart';
import 'package:stock_management_tool/objectbox.dart';
import 'package:stock_management_tool/services/firestore.dart';

class StockRepositoryImplementation implements StockRepository {
  final ObjectBox _objectBox = sl.get<ObjectBox>();

  @override
  Future<List<StockInputFieldModel>> getInitialInputFields() async {
    return [
      {
        "field": "category",
        "datatype": "string",
        "lockable": true,
        "isWithSKU": true,
        "isTitleCase": true,
        "isBg": false,
        "order": 2,
        "items": _objectBox.getCategories().map((e) => e.category!.toTitleCase()).toList()
      },
    ].map((e) => StockInputFieldModel.fromJson(e)).toList();
  }

  @override
  Future<List<StockInputFieldModel>> getCategoryBasedInputFields({required String category}) async {
    List fields = _objectBox
        .getInputFields()
        .where((element) =>
            !element.isBg! &&
            element.category == category.toLowerCase() &&
            element.field != "category")
        .map((e) {
      if (e.field == 'sku') {
        e.items = _objectBox
            .getProducts()
            .where((element) => element.category == category.toLowerCase())
            .map((e) => e.sku!)
            .toList();
      }
      return e.toJson();
    }).toList();

    return fields.map((e) => StockInputFieldModel.fromJson(e)).toList();

    // List fields = AllPredefinedData.data[category.toLowerCase()]["fields"]
    //     .where((element) => !element['isBg'] && element['field'] != 'category')
    //     .toList();
    // return fields.map((element) {
    //   if (element['field'] != 'sku') {
    //     return StockInputFieldModel.fromJson(element);
    //   } else {
    //     element['items'] = AllPredefinedData.data[category.toLowerCase()]["products"]
    //             .map((e) => e["sku"])
    //             .toList() ??
    //         [];
    //     return StockInputFieldModel.fromJson(element);
    //   }
    // }).toList();
  }

  @override
  Future<Map> getProductDescription({required String category, required String sku}) async {
    return _objectBox
        .getProducts()
        .where((element) => element.category == category.toLowerCase() && element.sku == sku)
        .map((e) => e.toJson())
        .toList()[0];

    // return AllPredefinedData.data[category.toLowerCase()]["products"]
    //     .where((e) => e["sku"] == sku)
    //     .toList()[0];
  }

  @override
  Future addNewStock({required List<dynamic> fields}) async {
    Map data = {};
    for (var element in fields) {
      data[element.field] = element.textValue;
    }
    await sl.get<Firestore>().createDocument(
          path: "stock_data",
          data: AddNewStockHelper.toJson(data: data),
        );
  }
}
