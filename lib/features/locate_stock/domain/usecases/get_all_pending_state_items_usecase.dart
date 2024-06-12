import 'package:stock_management_tool/core/usecase/usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/repositories/locate_stock_repository.dart';

class GetAllPendingStateItemsUseCase extends UseCase {
  GetAllPendingStateItemsUseCase(this._locateStockRepository);

  final LocateStockRepository _locateStockRepository;

  @override
  Future call({params}) async {
    Map<String, dynamic> locatedStock = params["located_stock"];

    locatedStock["pending_state_items"] =
        _locateStockRepository.getAllPendingStateItems({});

    locatedStock["layers"].add("pending_moves_overlay");

    return locatedStock;
  }
}
