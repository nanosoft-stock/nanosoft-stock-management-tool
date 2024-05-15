import 'package:stock_management_tool/core/usecase/usecase.dart';

class AddVisualizeStockLayerUseCase extends UseCase {
  AddVisualizeStockLayerUseCase();

  @override
  Future call({params}) async {
    String field = params["field"];
    Map<String, dynamic> visualizeStock = params["visualize_stock"];

    visualizeStock["layers"].add("field_filter");
    visualizeStock["filter_menu_field"] = field;

    return visualizeStock;
  }
}
