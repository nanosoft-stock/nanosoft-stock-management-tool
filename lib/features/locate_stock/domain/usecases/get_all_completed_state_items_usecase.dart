import 'package:stock_management_tool/core/usecase/usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/repositories/locate_stock_repository.dart';

class GetAllCompletedStateItemsUseCase extends UseCase {
  GetAllCompletedStateItemsUseCase(this._locateStockRepository);

  final LocateStockRepository _locateStockRepository;

  @override
  Future call({params}) async {
    Map<String, dynamic> locatedStock = params["located_stock"];

    locatedStock["layers"].add("completed_moves_overlay");
    locatedStock["completed_state_items"] =
        _locateStockRepository.getAllCompletedStateItems();

    return locatedStock;
  }
}
