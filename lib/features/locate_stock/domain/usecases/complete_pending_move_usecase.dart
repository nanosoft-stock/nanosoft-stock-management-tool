import 'package:stock_management_tool/core/usecase/usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/repositories/locate_stock_repository.dart';

class CompletePendingMoveUseCase extends UseCase {
  CompletePendingMoveUseCase(this._locateStockRepository);

  final LocateStockRepository _locateStockRepository;

  @override
  Future call({params}) async {
    int index = params["index"];
    Map<String, dynamic> locatedStock = params["located_stock"];
    Map<String, dynamic> pendingStateItems =
        locatedStock["pending_state_items"];

    List keys = locatedStock["pending_state_items"].keys.toList();

    await _locateStockRepository.changeMoveStateToComplete(
        pendingItems: pendingStateItems[keys[index]]);

    pendingStateItems =
        _locateStockRepository.getAllPendingStateItems(pendingStateItems);
    locatedStock["pending_state_items"] = pendingStateItems;

    return locatedStock;
  }
}
