import 'package:stock_management_tool/core/constants/enums.dart';
import 'package:stock_management_tool/core/usecase/usecase.dart';

class SwitchStockViewModeUseCase extends UseCase {
  SwitchStockViewModeUseCase();

  @override
  Future call({params}) async {
    int index = params["index"];
    StockViewMode mode = params["mode"];
    Map<String, dynamic> locatedStock = params["located_stock"];

    locatedStock["rows"][index]["view_mode"] = mode;

    return locatedStock;
  }
}
