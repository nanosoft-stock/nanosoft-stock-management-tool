import 'package:stock_management_tool/core/constants/enums.dart';
import 'package:stock_management_tool/core/usecase/usecase.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/repositories/visualize_stock_repository.dart';

class SortColumnVisualizeStockUseCase extends UseCase {
  SortColumnVisualizeStockUseCase(this._visualizeStockRepository);

  final VisualizeStockRepository _visualizeStockRepository;

  @override
  Future call({params}) async {
    String field = params["field"];
    Sort sort = params["sort"];
    Map<String, dynamic> visualizeStock = params["visualize_stock"];

    visualizeStock["filters"].forEach((k, v) {
      v["sort"] = Sort.none;
    });

    if (sort == Sort.none) {
      field = "date";
      sort = Sort.desc;
    }

    visualizeStock["filters"][field]["sort"] = sort;

    visualizeStock["stocks"] = _visualizeStockRepository.sortStocks(
        field: field, sort: sort, stocks: visualizeStock["stocks"]);

    return visualizeStock;
  }
}
