import 'package:stock_management_tool/core/usecase/usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/repositories/locate_stock_repository.dart';

class WarehouseLocationIDEnteredUseCase extends UseCase {
  WarehouseLocationIDEnteredUseCase(this._locateStockRepository);

  final LocateStockRepository _locateStockRepository;

  @override
  Future call({params}) async {
    Map<String, dynamic> selectedItems = params["selected_items"];

    String warehouseLocationId = selectedItems["warehouse_location_text"];

    if (selectedItems["warehouse_location_ids"].contains(warehouseLocationId)) {
      selectedItems["container_ids"] = await _locateStockRepository
          .getContainerIds(warehouseLocationId: warehouseLocationId);
    } else {
      selectedItems["container_ids"] =
          await _locateStockRepository.getIds(searchBy: "Container Id");
    }

    return selectedItems;
  }
}
