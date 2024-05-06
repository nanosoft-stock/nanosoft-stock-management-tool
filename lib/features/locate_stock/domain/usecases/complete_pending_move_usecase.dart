import 'package:stock_management_tool/core/usecase/usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/repositories/locate_stock_repository.dart';

class CompletePendingMoveUseCase extends UseCase {
  CompletePendingMoveUseCase(this._locateStockRepository);

  final LocateStockRepository _locateStockRepository;

  @override
  Future call({params}) async {
    int index = params["index"];
    List<Map<String, dynamic>> pendingStateItems =
        params["pending_state_items"];

    await _locateStockRepository.changeMoveStateToComplete(
        pendingItem: pendingStateItems[index]);

    pendingStateItems = _locateStockRepository.getAllPendingStateItems();

    return pendingStateItems;
  }
}
