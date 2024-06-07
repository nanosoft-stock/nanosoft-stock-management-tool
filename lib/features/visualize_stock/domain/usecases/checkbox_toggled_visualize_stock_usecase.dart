import 'package:stock_management_tool/core/usecase/usecase.dart';

class CheckboxToggledVisualizeStockUseCase extends UseCase {
  CheckboxToggledVisualizeStockUseCase();

  @override
  Future call({params}) async {
    String field = params["field"];
    String title = params["title"];
    bool? value = params["value"];
    Map<String, dynamic> visualizeStock = params["visualize_stock"];

    Map<String, dynamic> fieldFilter =
        visualizeStock["filters"].firstWhere((e) => e["field"] == field);

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

    return visualizeStock;
  }
}