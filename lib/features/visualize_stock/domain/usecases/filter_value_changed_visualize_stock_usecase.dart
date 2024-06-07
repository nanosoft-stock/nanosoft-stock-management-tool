import 'package:stock_management_tool/core/usecase/usecase.dart';

class FilterValueChangedVisualizeStockUseCase extends UseCase {
  FilterValueChangedVisualizeStockUseCase();

  @override
  Future call({params}) async {
    String field = params["field"];
    String filterValue = params["filter_value"];
    Map<String, dynamic> visualizeStock = params["visualize_stock"];

    visualizeStock["filters"]
        .firstWhere((e) => e["field"] == field)["filter_value"] = filterValue;

    return visualizeStock;
  }
}
