import 'package:stock_management_tool/core/usecase/usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/repositories/locate_stock_repository.dart';

class WarehouseLocationIDEnteredUseCase extends UseCase {
  WarehouseLocationIDEnteredUseCase(this._locateStockRepository);

  final LocateStockRepository _locateStockRepository;

  @override
  Future call({params}) async {
    String warehouseLocationId = params["text"];
    Map<String, dynamic> locatedStock = params["located_stock"];
    Map<String, dynamic> selectedItems = locatedStock["selected_items"];

    selectedItems["warehouse_location_text"] = warehouseLocationId;

    if (selectedItems["warehouse_location_ids"].contains(warehouseLocationId)) {
      List containers = _locateStockRepository.getContainerIds(
          warehouseLocationId: warehouseLocationId);
      if (containers.isNotEmpty) {
        selectedItems["container_ids"] = containers;
      } else {
        selectedItems["container_ids"] =
            locatedStock["all_ids"]["Container Id"];
      }
    } else {
      selectedItems["container_ids"] = locatedStock["all_ids"]["Container Id"];
    }

    return locatedStock;
  }
}
