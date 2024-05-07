import 'package:stock_management_tool/core/usecase/usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/repositories/locate_stock_repository.dart';

class IdsChosenUseCase extends UseCase {
  IdsChosenUseCase(this._locateStockRepository);

  final LocateStockRepository _locateStockRepository;

  @override
  Future call({params}) async {
    int index = params["index"];
    List chosenIds = params["chosen_ids"];
    Map<String, dynamic> locatedStock = params["located_stock"];

    locatedStock["rows"][index]["chosen_ids"] = chosenIds.toSet().toList();

    Map<String, dynamic> details = _locateStockRepository.getChosenIdsDetails(
      searchBy: locatedStock["rows"][index]["search_by"],
      chosenIds: chosenIds,
      selectedItemIds: locatedStock["selected_item_ids"],
    );

    for (var key in details.keys) {
      locatedStock['rows'][index][key] = details[key];
    }

    locatedStock["layers"].remove("multiple_search_selection_overlay");

    return locatedStock;
  }
}
