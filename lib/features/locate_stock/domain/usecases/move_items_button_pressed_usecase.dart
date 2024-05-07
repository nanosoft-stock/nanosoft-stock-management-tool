import 'package:stock_management_tool/core/usecase/usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/repositories/locate_stock_repository.dart';

class MoveItemsButtonPressedUseCase extends UseCase {
  MoveItemsButtonPressedUseCase(this._locateStockRepository);

  final LocateStockRepository _locateStockRepository;

  @override
  Future call({params}) async {
    Map<String, dynamic> locatedStock = params["located_stock"];

    await _locateStockRepository.moveItemsToPendingState(
        selectedItems: locatedStock["selected_items"]);

    locatedStock["selected_items"] = {};
    locatedStock["layers"].remove("preview_move_overlay");

    return locatedStock;
  }
}
