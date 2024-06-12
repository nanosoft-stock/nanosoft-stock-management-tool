import 'package:stock_management_tool/core/usecase/usecase.dart';

class FilterBySelectedLocateStockUseCase extends UseCase {
  FilterBySelectedLocateStockUseCase();

  @override
  Future call({params}) async {
    int index = params["index"];
    String field = params["field"];
    String filterBy = params["filter_by"];
    Map<String, dynamic> locatedStock = params["located_stock"];

    locatedStock["rows"][index]["filters"][field]["filter_by"] = filterBy;

    return locatedStock;
  }
}
