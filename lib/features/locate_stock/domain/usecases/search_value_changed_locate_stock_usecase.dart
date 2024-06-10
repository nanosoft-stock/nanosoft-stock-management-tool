import 'package:stock_management_tool/core/usecase/usecase.dart';

class SearchValueChangedLocateStockUseCase extends UseCase {
  SearchValueChangedLocateStockUseCase();

  @override
  Future call({params}) async {
    int index = params["index"];
    String field = params["field"];
    String searchValue = params["value"].toLowerCase();
    Map<String, dynamic> locatedStock = params["located_stock"];

    Map<String, dynamic> fieldFilter = locatedStock["rows"][index]["filters"]
        .firstWhere((e) => e["field"] == field);

    fieldFilter["search_value"] = searchValue;

    List allUniqueValues = fieldFilter["all_unique_values"];

    for (var e in allUniqueValues) {
      e["show"] = e["title"].toLowerCase().contains(searchValue) ? true : false;
    }

    fieldFilter["all_unique_values"] = allUniqueValues;

    return locatedStock;
  }
}
