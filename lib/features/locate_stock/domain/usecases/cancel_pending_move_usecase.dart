import 'package:stock_management_tool/core/usecase/usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/repositories/locate_stock_repository.dart';

class CancelPendingMoveUseCase extends UseCase {
  CancelPendingMoveUseCase(this._locateStockRepository);

  final LocateStockRepository _locateStockRepository;

  @override
  Future call({params}) async {
    int index = params["index"];
    Map<String, dynamic> locatedStock = params["located_stock"];
    List pendingStateItems = locatedStock["pending_state_items"];

    await _locateStockRepository.cancelPendingMove(
        pendingItem: pendingStateItems[index]);

    pendingStateItems =
        _locateStockRepository.getAllPendingStateItems(pendingStateItems);
    locatedStock["pending_state_items"] = pendingStateItems;

    return locatedStock;
  }
}
