import 'package:stock_management_tool/core/usecase/usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/repositories/locate_stock_repository.dart';

class MoveItemsButtonPressedUseCase extends UseCase {
  MoveItemsButtonPressedUseCase(this._locateStockRepository);

  final LocateStockRepository _locateStockRepository;

  @override
  Future call({params}) async {
    Map<String, dynamic> selectedItems = params["selected_items"];

    return await _locateStockRepository.moveItemsToPendingState(
        selectedItems: selectedItems);
  }
}
