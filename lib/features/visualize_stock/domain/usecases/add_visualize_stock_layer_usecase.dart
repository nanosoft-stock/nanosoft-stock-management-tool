import 'package:stock_management_tool/core/usecase/usecase.dart';

class AddVisualizeStockLayerUseCase extends UseCase {
  AddVisualizeStockLayerUseCase();

  @override
  Future call({params}) async {
    String? field = params["field"];
    String? layer = params["layer"];
    Map<String, dynamic> visualizeStock = params["visualize_stock"];

    if (layer != null) {
      visualizeStock["layers"].remove("field_filter");
      visualizeStock["layers"].add(layer);
    } else {
      visualizeStock["layers"].remove("parent_filter");
      visualizeStock["layers"].add("field_filter");
      visualizeStock["filter_menu_field"] = field;
    }

    return visualizeStock;
  }
}
