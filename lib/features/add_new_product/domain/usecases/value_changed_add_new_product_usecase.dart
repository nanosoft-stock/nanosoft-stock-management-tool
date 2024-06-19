import 'package:stock_management_tool/core/usecase/usecase.dart';
import 'package:stock_management_tool/features/add_new_product/domain/repositories/product_repository.dart';

class ValueChangedAddNewProductUseCase extends UseCase {
  ValueChangedAddNewProductUseCase(this._productRepository);

  final ProductRepository _productRepository;

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
        fields = _productRepository.getCategoryBasedInputFields(
            category: value,
            sku: fields.firstWhere((e) => e["field"] == "sku")["text_value"]);
      } else {
        fields = _productRepository.getInitialInputFields();
        fields[0]["text_value"] = value;
        fields[1]["text_value"] =
            fields.firstWhere((e) => e["field"] == "sku")["text_value"];
      }
    }

    return fields;
  }
}
