import 'package:stock_management_tool/core/usecase/usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/repositories/locate_stock_repository.dart';

class ContainerIDEnteredUseCase extends UseCase {
  ContainerIDEnteredUseCase(this._locateStockRepository);

  final LocateStockRepository _locateStockRepository;

  @override
  Future call({params}) async {
    String containerId = params["text"];
    Map<String, dynamic> selectedItems = params["selected_items"];

    selectedItems["container_text"] = containerId;

    if (selectedItems["container_ids"].contains(containerId)) {
      selectedItems["warehouse_location_text"] = _locateStockRepository
          .getWarehouseLocationId(containerId: containerId);
    }

    return selectedItems;
  }
}
