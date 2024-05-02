import 'package:stock_management_tool/core/usecase/usecase.dart';
import 'package:stock_management_tool/features/add_new_stock/domain/repositories/stock_repository.dart';

class AddNewStockUseCase extends UseCase {
  AddNewStockUseCase(this._stockRepository);

  final StockRepository _stockRepository;

  @override
  Future call({params}) async {
    List fields = params;

    await _stockRepository.addNewStock(fields: params);

    if (fields[0].field == "category" && fields[0].locked == true) {
      for (int i = 0; i < fields.length; i++) {
        if (!fields[i].locked) {
          fields[i] = fields[i].copyWith(textValue: "");
        }
      }
    } else {
      fields = await _stockRepository.getInitialInputFields();
    }

    return fields;
  }
}
