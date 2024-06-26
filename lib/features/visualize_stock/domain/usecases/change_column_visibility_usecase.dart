import 'package:stock_management_tool/core/usecase/usecase.dart';

class ChangeColumnVisibilityUseCase extends UseCase {
  ChangeColumnVisibilityUseCase();

  @override
  Future call({params}) async {
    String field = params["field"];
    bool visibility = params["visibility"];
    Map<String, dynamic> visualizeStock = params["visualize_stock"];

    visualizeStock["filters"][field]["show_column"] = visibility;

    List showFields = [];
    for (var field in visualizeStock["fields"]) {
      if (visualizeStock["filters"][field]["show_column"] == true) {
        showFields.add(field);
      }
    }

    visualizeStock["show_fields"] = showFields;

    return visualizeStock;
  }
}
