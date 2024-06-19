import 'package:stock_management_tool/core/usecase/usecase.dart';

class RearrangeColumnsUseCase extends UseCase {
  RearrangeColumnsUseCase();

  @override
  Future call({params}) async {
    List fields = params["fields"];
    Map<String, dynamic> visualizeStock = params["visualize_stock"];

    List showFields = [];
    for (var field in fields) {
      if (visualizeStock["filters"][field]["show_column"] == true) {
        showFields.add(field);
      }
    }

    visualizeStock["fields"] = fields;
    visualizeStock["show_fields"] = showFields;

    return visualizeStock;
  }
}
