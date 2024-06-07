import 'package:stock_management_tool/constants/enums.dart';
import 'package:stock_management_tool/core/usecase/usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/repositories/locate_stock_repository.dart';

class IdCheckBoxToggledUseCase extends UseCase {
  IdCheckBoxToggledUseCase(this._locateStockRepository);

  final LocateStockRepository _locateStockRepository;

  @override
  Future call({params}) async {
    int index = params["index"];
    String id = params["id"];
    CheckBoxState state = params["state"];
    Map<String, dynamic> locatedStock = params["located_stock"];

    List selectedItemIds = locatedStock["selected_item_ids"];
    StockViewMode currentMode = locatedStock["rows"][index]["view_mode"];
    List rowItems = locatedStock["rows"][index]["items"];
    List items = [];

    if (currentMode == StockViewMode.item) {
      items = [id];
    } else if (currentMode == StockViewMode.container) {
      items = rowItems
          .where((e) => e["container_id"] == id)
          .map((e) => e["item_id"])
          .toList();
    } else if (currentMode == StockViewMode.warehouse) {
      items = rowItems
          .where((e) => e["warehouse_location_id"] == id)
          .map((e) => e["item_id"])
          .toList();
    }

    if (state == CheckBoxState.all) {
      selectedItemIds.addAll(items);
    } else {
      for (var element in items) {
        selectedItemIds.remove(element);
      }
    }
    locatedStock["selected_item_ids"] = selectedItemIds.toSet().toList();

    return _locateStockRepository.changeAllStockState(
        locatedStock: locatedStock);
  }
}
