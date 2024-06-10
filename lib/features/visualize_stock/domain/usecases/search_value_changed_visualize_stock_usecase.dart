import 'package:stock_management_tool/core/usecase/usecase.dart';

class SearchValueChangedVisualizeStockUseCase extends UseCase {
  SearchValueChangedVisualizeStockUseCase();

  @override
  Future call({params}) async {
    String field = params["field"];
    String searchValue = params["search_value"].toLowerCase();
    Map<String, dynamic> visualizeStock = params["visualize_stock"];

    Map<String, dynamic> fieldFilter =
        visualizeStock["filters"].firstWhere((e) => e["field"] == field);

    fieldFilter["search_value"] = searchValue;

    List allUniqueValues = fieldFilter["all_unique_values"];

    for (var e in allUniqueValues) {
      e["show"] = e["title"].toLowerCase().contains(searchValue) ? true : false;
    }

    fieldFilter["all_unique_values"] = allUniqueValues;

    return visualizeStock;
  }
}
