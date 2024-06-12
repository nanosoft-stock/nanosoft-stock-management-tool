import 'package:stock_management_tool/core/usecase/usecase.dart';

class RearrangeColumnsUseCase extends UseCase {
  RearrangeColumnsUseCase();

  @override
  Future call({params}) async {
    List fieldFilters = params["field_filters"];
    Map<String, dynamic> visualizeStock = params["visualize_stock"];

    // visualizeStock["filters"] = fieldFilters.cast<Map<String, dynamic>>();
    //
    // List showFields = [];
    // for (var field in visualizeStock["filters"]) {
    //   if (field["show_column"]) {
    //     showFields.add(field["field"]);
    //   }
    // }

    List showFields = [];
    for (var e in fieldFilters) {
      if (visualizeStock["filters"][e.field]["show_column"] == true) {
        showFields.add(e.field);
      }
    }

    visualizeStock["fields"] = fieldFilters;
    visualizeStock["show_fields"] = showFields;

    return visualizeStock;
  }
}
