import 'package:stock_management_tool/core/usecase/usecase.dart';
import 'package:stock_management_tool/features/add_new_stock/domain/repositories/stock_repository.dart';

class ListenToCloudDataChangeAddNewStockUseCase extends UseCase {
  ListenToCloudDataChangeAddNewStockUseCase(this._stockRepository);

  final StockRepository _stockRepository;

  @override
  Future call({params}) async {
    return _stockRepository.listenToCloudDataChange(
        fields: params["fields"], onChange: params["on_change"]);
  }
}
