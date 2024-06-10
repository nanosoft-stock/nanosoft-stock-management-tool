import 'package:stock_management_tool/core/usecase/usecase.dart';

class FilterCheckboxToggledLocateStockUseCase extends UseCase {
  FilterCheckboxToggledLocateStockUseCase();

  @override
  Future call({params}) async {
    int index = params["index"];
    String field = params["field"];
    String title = params["title"];
    bool? value = params["value"];
    Map<String, dynamic> locatedStock = params["located_stock"];

    Map<String, dynamic> fieldFilter = locatedStock["rows"][index]["filters"]
        .firstWhere((e) => e["field"] == field);

    if (title == "select_all") {
      fieldFilter["all_unique_values"]
          .where((e) => e["show"] == true)
          .forEach((e) {
        e["selected"] = value;
      });
    } else {
      fieldFilter["all_unique_values"]
          .firstWhere((e) => e["title"] == title)["selected"] = value;
    }

    bool? allSelected;

    if (fieldFilter["all_unique_values"]
        .where((e) => e["show"] == true)
        .every((e) => e["selected"] == true)) {
      allSelected = true;
    } else if (fieldFilter["all_unique_values"]
        .where((e) => e["show"] == true)
        .any((e) => e["selected"] == true)) {
      allSelected = null;
    } else {
      allSelected = false;
    }

    fieldFilter["all_selected"] = allSelected;

    return locatedStock;
  }
}
