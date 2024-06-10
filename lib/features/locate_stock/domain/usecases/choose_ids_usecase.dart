import 'package:stock_management_tool/core/usecase/usecase.dart';

class ChooseIdsUseCase extends UseCase {
  ChooseIdsUseCase();

  @override
  Future call({params}) async {
    int index = params["index"];
    Map<String, dynamic> locatedStock = params["located_stock"];

    if (locatedStock["rows"][index]["search_by"] != "Filter") {
      locatedStock["layers"].add("multiple_search_selection_overlay");
    } else {
      locatedStock["layers"].add("parent_filter_overlay");
    }

    return locatedStock;
  }
}
