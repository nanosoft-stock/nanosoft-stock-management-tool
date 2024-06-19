import 'package:stock_management_tool/core/usecase/usecase.dart';
import 'package:stock_management_tool/features/add_new_stock/domain/repositories/stock_repository.dart';

class AddNewStockUseCase extends UseCase {
  AddNewStockUseCase(this._stockRepository);

  final StockRepository _stockRepository;

  @override
  Future call({params}) async {
    List fields = params["fields"];

    await _stockRepository.addNewStock(fields: fields);

    if (fields[0]["field"] == "category" && fields[0]["is_disabled"] == true) {
      for (int i = 0; i < fields.length; i++) {
        if (!fields[i]["is_disabled"]) {
          fields[i]["text_value"] = "";
        }
      }
    } else {
      fields = _stockRepository.getInitialInputFields();
    }

    return fields;
  }
}
