import 'package:stock_management_tool/core/usecase/usecase.dart';

class HideVisualizeStockLayerUseCase extends UseCase {
  HideVisualizeStockLayerUseCase();

  @override
  Future call({params}) async {
    String layer = params["layer"];
    Map<String, dynamic> visualizeStock = params["visualize_stock"];

    visualizeStock["layers"].remove(layer);
    visualizeStock["filter_menu_field"] = null;

    return visualizeStock;
  }
}
