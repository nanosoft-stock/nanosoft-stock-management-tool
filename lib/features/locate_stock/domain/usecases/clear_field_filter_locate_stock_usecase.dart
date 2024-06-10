import 'package:stock_management_tool/core/usecase/usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/repositories/locate_stock_repository.dart';

class ClearFieldFilterLocateStockUseCase extends UseCase {
  ClearFieldFilterLocateStockUseCase(this._locateStockRepository);

  final LocateStockRepository _locateStockRepository;

  @override
  Future call({params}) async {
    int index = params["index"];
    String field = params["field"];
    Map<String, dynamic> locatedStock = params["located_stock"];

    Map<String, dynamic> fieldFilter = locatedStock["rows"][index]["filters"]
        .firstWhere((e) => e["field"] == field);

    fieldFilter["filter_by"] = "";
    fieldFilter["filter_value"] = "";
    fieldFilter["search_value"] = "";
    fieldFilter["all_unique_values"]
        // .where((e) => e["show"] == true)
        .forEach((e) {
      e["selected"] = true;
    });

    List filteredStocks = _locateStockRepository.getFilteredStocks(
      filters: locatedStock["rows"][index]["filters"],
    );

    List chosenIds = filteredStocks.map((e) => e["item id"]).toSet().toList();

    locatedStock["rows"][index]["chosen_ids"] = chosenIds;

    Map<String, dynamic> details = _locateStockRepository.getChosenIdsDetails(
      searchBy: "Item Id",
      chosenIds: chosenIds,
      selectedItemIds: locatedStock["selected_item_ids"],
    );

    for (var key in details.keys) {
      locatedStock['rows'][index][key] = details[key];
    }

    for (var filter in locatedStock["rows"][index]["filters"]) {
      List uniqueValues =
          filteredStocks.map((e) => e[filter["field"]]).toSet().toList();

      filter["all_unique_values"].forEach((e) {
        if (uniqueValues.contains(e["title"])) {
          e["show"] = true;
        } else {
          e["show"] = false;
        }
      });

      bool? allSelected;

      if (filter["all_unique_values"]
          .where((e) => e["show"] == true)
          .every((e) => e["selected"] == true)) {
        allSelected = true;
      } else if (filter["all_unique_values"]
          .where((e) => e["show"] == true)
          .any((e) => e["selected"] == true)) {
        allSelected = null;
      } else {
        allSelected = false;
      }

      filter["all_selected"] = allSelected;
    }

    return locatedStock;
  }
}
