import 'package:stock_management_tool/core/usecase/usecase.dart';
import 'package:stock_management_tool/features/add_new_stock/domain/repositories/stock_repository.dart';

class ValueChangedAddNewStockUseCase extends UseCase {
  ValueChangedAddNewStockUseCase(this._stockRepository);

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
        List<Map<String, dynamic>> newFields =
            await _stockRepository.getCategoryBasedInputFields(category: value);
        fields.addAll(newFields);
        fields[0]["text_value"] = value;
      } else {
        fields.removeWhere((e) => e["field"] != "category");
        fields[0]["text_value"] = value;
      }
    } else if (field == "sku") {
      if (fieldMap["items"].contains(value)) {
        fields = _stockRepository.getProductDescription(
            category: fields[0]["text_value"], sku: value, fields: fields);
      }
    } else if (field == "container id") {
      if (fieldMap["items"].contains(value)) {
        String warehouseLocationId =
            _stockRepository.getWarehouseLocationId(containerId: value);
        fields.firstWhere(
                (e) => e["field"] == "warehouse location id")["text_value"] =
            warehouseLocationId;
      }
    }

    return fields;
  }
}
