import 'package:stock_management_tool/core/usecase/usecase.dart';
import 'package:stock_management_tool/features/add_new_stock/domain/repositories/stock_repository.dart';

class GetStockCategoryBasedInputFieldsUseCase extends UseCase {
  GetStockCategoryBasedInputFieldsUseCase(this._stockRepository);

  final StockRepository _stockRepository;

  @override
  Future call({params}) {
    return _stockRepository.getCategoryBasedInputFields(category: params);
  }
}
