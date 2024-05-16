import 'package:stock_management_tool/core/usecase/usecase.dart';

class FilterBySelectedVisualizeStockUseCase extends UseCase {
  FilterBySelectedVisualizeStockUseCase();

  @override
  Future call({params}) async {
    String field = params["field"];
    String filterBy = params["filter_by"];
    Map<String, dynamic> visualizeStock = params["visualize_stock"];

    visualizeStock["filters"]
        .firstWhere((e) => e["field"] == field)["filter_by"] = filterBy;

    return visualizeStock;
  }
}
