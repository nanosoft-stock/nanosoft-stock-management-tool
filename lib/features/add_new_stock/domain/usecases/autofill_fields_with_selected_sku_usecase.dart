import 'package:stock_management_tool/core/usecase/usecase.dart';
import 'package:stock_management_tool/features/add_new_stock/domain/repositories/stock_repository.dart';

class AutofillFieldsWithSelectedSkuUseCase extends UseCase {
  AutofillFieldsWithSelectedSkuUseCase(this._stockRepository);

  final StockRepository _stockRepository;

  @override
  Future call({params}) async {
    final skuElement = params[params.indexWhere((element) => element.field == 'sku')];
    var productDesc = await _stockRepository.getProductDescription(
        category: params[0].textValue, sku: skuElement.textValue);

    var affectedFields =
        params.where((element) => element.isWithSKU && element.field != "category").toList();

    for (var element in affectedFields) {
      print("${element.field}, ${element.textValue}");
      params[params.indexOf(element)] =
          element.copyWith(textValue: productDesc[element.field.toString()].toString());
    }

    return params;
  }
}
