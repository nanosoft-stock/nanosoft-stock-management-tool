import 'package:stock_management_tool/core/usecase/usecase.dart';
import 'package:stock_management_tool/features/add_new_stock/domain/repositories/stock_repository.dart';

class GetStockInitialInputFieldsUseCase extends UseCase {
  GetStockInitialInputFieldsUseCase(this._stockRepository);

  final StockRepository _stockRepository;

  @override
  Future call({params}) {
    return _stockRepository.getInitialInputFields();
  }
}
