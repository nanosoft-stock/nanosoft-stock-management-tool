import 'package:stock_management_tool/core/usecase/usecase.dart';

class AddOverlayLayerUseCase extends UseCase {
  AddOverlayLayerUseCase();

  @override
  Future call({params}) async {
    String layer = params["layer"];
    Map<String, dynamic> locatedStock = params["located_stock"];

    locatedStock["layers"].add(layer);

    return locatedStock;
  }
}
