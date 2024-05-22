import 'package:stock_management_tool/core/usecase/usecase.dart';

class ChangeColumnVisibilityUseCase extends UseCase {
  ChangeColumnVisibilityUseCase();

  @override
  Future call({params}) async {
    String field = params["field"];
    bool visibility = params["visibility"];
    Map<String, dynamic> visualizeStock = params["visualize_stock"];

    visualizeStock["filters"]
        .firstWhere((e) => e["field"] == field)["show_column"] = visibility;

    List showFields = [];
    for (var field in visualizeStock["filters"]) {
      if (field["show_column"]) {
        showFields.add(field["field"]);
      }
    }

    visualizeStock["show_fields"] = showFields;

    return visualizeStock;
  }
}
