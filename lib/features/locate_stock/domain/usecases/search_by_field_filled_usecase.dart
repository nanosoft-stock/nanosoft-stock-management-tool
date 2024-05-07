import 'package:stock_management_tool/constants/enums.dart';
import 'package:stock_management_tool/core/usecase/usecase.dart';

class SearchByFieldFilledUseCase extends UseCase {
  SearchByFieldFilledUseCase();

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
    }

    locatedStock["rows"][index]["view_mode"] = mode;
    if (locatedStock["rows"][index]["chosen_ids"] == null) {
      locatedStock["rows"][index]["chosen_ids"] = [];
    }
    locatedStock["layers"].add("multiple_search_selection_overlay");

    return locatedStock;
  }
}
