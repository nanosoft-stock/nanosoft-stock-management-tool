import 'package:stock_management_tool/features/add_new_stock/data/models/stock_input_field_model.dart';
import 'package:stock_management_tool/features/add_new_stock/domain/repositories/stock_repository.dart';
import 'package:stock_management_tool/helper/add_new_stock_helper.dart';
import 'package:stock_management_tool/helper/string_casting_extension.dart';
import 'package:stock_management_tool/models/all_predefined_data.dart';
import 'package:stock_management_tool/services/firestore.dart';

class StockRepositoryImplementation implements StockRepository {
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
        "order": "2",
        "items": AllPredefinedData.data["categories"]
            .map(
              (e) => e.toString().toTitleCase(),
            )
            .toList()
      },
    ].map((e) => StockInputFieldModel.fromJson(e)).toList();
  }

  @override
  Future<List<StockInputFieldModel>> getCategoryBasedInputFields({required String category}) async {
    List fields = AllPredefinedData.data[category.toLowerCase()]["fields"]
        .where((element) => !element['isBg'] && element['field'] != 'category')
        .toList();
    return fields.map((element) {
      if (element['field'] != 'sku') {
        return StockInputFieldModel.fromJson(element);
      } else {
        element['items'] = AllPredefinedData.data[category.toLowerCase()]["products"]
                .map((e) => e["sku"])
                .toList() ??
            [];
        return StockInputFieldModel.fromJson(element);
      }
    }).toList();
  }

  @override
  Future<Map> getProductDescription({required category, required sku}) async {
    return AllPredefinedData.data[category.toLowerCase()]["products"]
        .where((e) => e["sku"] == sku)
        .toList()[0];
  }

  @override
  Future addNewStock({required List<dynamic> fields}) async {
    Map data = {};
    for (var element in fields) {
      data[element.field] = element.textValue;
    }
    await Firestore().createDocument(
      path: "stock_data",
      data: AddNewStockHelper.toJson(data: data),
    );
  }
}
