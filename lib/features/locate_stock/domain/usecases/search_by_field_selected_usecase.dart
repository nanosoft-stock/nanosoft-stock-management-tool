import 'package:stock_management_tool/core/usecase/usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/repositories/locate_stock_repository.dart';

class SearchByFieldSelectedUseCase extends UseCase {
  SearchByFieldSelectedUseCase(this._locateStockRepository);

  final LocateStockRepository _locateStockRepository;

  @override
  Future call({params}) async {
    int index = params["index"];
    String searchBy = params["search_by"];
    List<Map<String, dynamic>> locatedItems = params["located_items"];

    locatedItems[index]["search_by"] = searchBy;

    locatedItems[index]["all_ids"] = await _locateStockRepository.getIds(searchBy: searchBy);

    locatedItems[index]["show_details"] =
        locatedItems[index]["search_by"] != "Item Id" ? false : true;

    if (locatedItems[index]["selected_ids"] != null) {
      locatedItems[index]["selected_ids"] = [];
    }

    if (locatedItems[index]["selected_ids_details"] != null) {
      locatedItems[index]["selected_ids_details"] = [];
    }

    return locatedItems;
  }
}
