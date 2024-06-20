import 'package:stock_management_tool/core/usecase/usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/repositories/locate_stock_repository.dart';

class GetSelectedItemsUseCase extends UseCase {
  GetSelectedItemsUseCase(this._locateStockRepository);

  final LocateStockRepository _locateStockRepository;

  @override
  Future call({params}) async {
    Map<String, dynamic> locatedStock = params["located_stock"];
    Map<String, dynamic> data = {};

    data["items"] = _locateStockRepository.getSelectedIdsDetails(
        selectedItemIds: locatedStock["selected_item_ids"]);
    data["container_ids"] = locatedStock["all_ids"]["Container Id"];
    data["warehouse_location_ids"] =
        locatedStock["all_ids"]["Warehouse Location Id"];
    data["container_text"] = "";
    data["warehouse_location_text"] = "";

    locatedStock["selected_items"] = data;

    locatedStock["layers"].add("preview_move_overlay");

    return locatedStock;
  }
}
