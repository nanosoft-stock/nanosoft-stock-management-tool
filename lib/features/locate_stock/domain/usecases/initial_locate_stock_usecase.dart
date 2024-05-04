import 'package:stock_management_tool/core/usecase/usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/repositories/locate_stock_repository.dart';

class InitialLocateStockUseCase extends UseCase {
  InitialLocateStockUseCase(this._locateStockRepository);

  final LocateStockRepository _locateStockRepository;

  @override
  Future call({params}) async {
    Map<String, dynamic> locatedStock = {};

    locatedStock["all_ids"] = _locateStockRepository.getAllIds();
    locatedStock["selected_item_ids"] = [];
    locatedStock["rows"] = [
      {
        "search_by": "",
        "show_table": true,
      },
    ];

    return locatedStock;
  }
}
