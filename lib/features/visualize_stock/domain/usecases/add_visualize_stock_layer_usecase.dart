import 'package:stock_management_tool/core/usecase/usecase.dart';

class AddVisualizeStockLayerUseCase extends UseCase {
  AddVisualizeStockLayerUseCase();

  @override
  Future call({params}) async {
    String? field = params["field"];
    String? layer = params["layer"];
    Map<String, dynamic> visualizeStock = params["visualize_stock"];

    visualizeStock["layers"].add(layer);
    if (layer != "parent_filter") {
      visualizeStock["filter_menu_field"] = field;
      visualizeStock["layers"].remove("parent_filter");
    } else {
      visualizeStock["filter_menu_field"] = null;
    }

    return visualizeStock;
  }
}
