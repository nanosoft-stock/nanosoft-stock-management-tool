import 'package:stock_management_tool/core/usecase/usecase.dart';

class FilterByValueChangedLocateStockUseCase extends UseCase {
  FilterByValueChangedLocateStockUseCase();

  @override
  Future call({params}) async {
    int index = params["index"];
    String field = params["field"];
    String value = params["value"];
    Map<String, dynamic> locatedStock = params["located_stock"];

    locatedStock["rows"][index]["filters"][field]["filter_value"] = value;

    return locatedStock;
  }
}
