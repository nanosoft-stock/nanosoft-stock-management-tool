import 'package:stock_management_tool/core/constants/enums.dart';
import 'package:stock_management_tool/core/usecase/usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/repositories/locate_stock_repository.dart';

class SearchByFieldFilledUseCase extends UseCase {
  SearchByFieldFilledUseCase(this._locateStockRepository);

  final LocateStockRepository _locateStockRepository;

  @override
  Future call({params}) async {
    int index = params["index"];
    String searchBy = params["search_by"];
    Map<String, dynamic> locatedStock = params["located_stock"];

    locatedStock["rows"][index]["search_by"] = searchBy;

    StockViewMode mode = StockViewMode.item;

    if (searchBy == "Item Id") {
      mode = StockViewMode.item;
    } else if (searchBy == "Container Id") {
      mode = StockViewMode.container;
    } else if (searchBy == "Warehouse Location Id") {
      mode = StockViewMode.warehouse;
    } else {
      mode = StockViewMode.item;
    }

    locatedStock["rows"][index]["view_mode"] = mode;
    if (searchBy != "Filter") {
      if (locatedStock["rows"][index]["chosen_ids"] == null) {
        locatedStock["rows"][index]["chosen_ids"] = [];
      }
      locatedStock["layers"].add("multiple_search_selection_overlay");
    } else {
      locatedStock["rows"][index]["filters"] =
          _locateStockRepository.getInitialFilters();
      locatedStock["layers"].add("parent_filter_overlay");
    }
    return locatedStock;
  }
}
