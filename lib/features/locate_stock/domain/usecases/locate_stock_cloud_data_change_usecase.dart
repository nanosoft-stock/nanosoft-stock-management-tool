import 'package:stock_management_tool/core/usecase/usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/repositories/locate_stock_repository.dart';

class LocateStockCloudDataChangeUseCase extends UseCase {
  LocateStockCloudDataChangeUseCase(this._locateStockRepository);

  final LocateStockRepository _locateStockRepository;

  @override
  Future call({params}) async {
    return await _locateStockRepository.listenToCloudDataChange(
      locatedStock: params["located_stock"],
      onChange: params["on_change"],
    );
  }
}
