import 'package:stock_management_tool/core/usecase/usecase.dart';

class HideVisualizeStockLayerUseCase extends UseCase {
  HideVisualizeStockLayerUseCase();

  @override
  Future call({params}) async {
    String layer = params["layer"];
    Map<String, dynamic> visualizeStock = params["visualize_stock"];

    visualizeStock["layers"].remove(layer);

    if (layer != "parent_filter") {
      visualizeStock["filter_menu_field"] = null;
    } else {
      visualizeStock["layers"].remove("parent_field_filter");
    }

    return visualizeStock;
  }
}
