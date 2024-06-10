import 'package:stock_management_tool/core/usecase/usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/repositories/locate_stock_repository.dart';

class ResetAllFiltersLocateStockUseCase extends UseCase {
  ResetAllFiltersLocateStockUseCase(this._locateStockRepository);

  final LocateStockRepository _locateStockRepository;

  @override
  Future call({params}) async {
    int index = params["index"];
    Map<String, dynamic> locatedStock = params["located_stock"];

    locatedStock["rows"][index]["filters"] =
        _locateStockRepository.getInitialFilters();

    locatedStock["rows"][index]["chosen_ids"] = [];
    locatedStock["rows"][index]["items"] = [];
    locatedStock["rows"][index]["containers"] = [];
    locatedStock["rows"][index]["warehouse_locations"] = [];

    return locatedStock;
  }
}
