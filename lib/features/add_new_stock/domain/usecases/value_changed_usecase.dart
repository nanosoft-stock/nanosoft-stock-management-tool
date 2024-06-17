import 'package:stock_management_tool/core/helper/case_helper.dart';
import 'package:stock_management_tool/core/usecase/usecase.dart';
import 'package:stock_management_tool/features/add_new_stock/domain/repositories/stock_repository.dart';

class ValueChangedUseCase extends UseCase {
  ValueChangedUseCase(this._stockRepository);

  final StockRepository _stockRepository;

  @override
  Future call({params}) async {
    String field = params["field"];
    String value = params["value"];
    List<Map<String, dynamic>> fields = params["fields"];

    Map<String, dynamic> fieldMap =
        fields.firstWhere((e) => e["field"] == field);

    fieldMap["text_value"] = value;

    if (field == "category") {
      if (fieldMap["items"].contains(value)) {
        fields = _stockRepository.getCategoryBasedInputFields(category: value);
      }
    } else if (field == "sku") {
      if (fieldMap["items"].contains(value)) {
        Map productDesc = _stockRepository.getProductDescription(
            category: fields[0]["text_value"], sku: value);

        List affectedFields = fields
            .where((element) =>
                element["in_sku"] && element["field"] != "category")
            .toList();

        for (var element in affectedFields) {
          fields.firstWhere(
                  (e) => e["field"] == element["field"])["text_value"] =
              CaseHelper.convert(
                  element["value_case"], productDesc[element["field"]]);
        }
      }
    } else if (field == "container id") {
      fields.firstWhere(
              (e) => e["field"] == "warehouse location id")["text_value"] =
          _stockRepository.getWarehouseLocationId(containerId: value);
    }

    return fields;
  }
}
