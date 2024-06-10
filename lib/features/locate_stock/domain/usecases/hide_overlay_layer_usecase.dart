import 'package:stock_management_tool/core/usecase/usecase.dart';

class HideOverlayLayerUseCase extends UseCase {
  HideOverlayLayerUseCase();

  @override
  Future call({params}) async {
    String layer = params["layer"];
    Map<String, dynamic> locatedStock = params["located_stock"];

    locatedStock["layers"].remove(layer);

    if (layer == "field_filter_overlay") {
      locatedStock["layers"].remove("field_filter_overlay");
      // locatedStock["rows"][rowIndex]["filter_field"] = null;
    }

    return locatedStock;
  }
}
