import 'package:stock_management_tool/core/usecase/usecase.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/repositories/visualize_stock_repository.dart';

class FilterValueEnteredVisualizeStockUseCase extends UseCase {
  FilterValueEnteredVisualizeStockUseCase(this._visualizeStockRepository);

  final VisualizeStockRepository _visualizeStockRepository;

  @override
  Future call({params}) async {
    String field = params["field"];
    String filterValue = params["filter_value"];
    Map<String, dynamic> visualizeStock = params["visualize_stock"];

    visualizeStock["filters"]
        .firstWhere((e) => e["field"] == field)["filter_value"] = filterValue;

    visualizeStock["stocks"] = _visualizeStockRepository.getFilteredStocks(
        filters: visualizeStock["filters"]);

    return visualizeStock;
  }
}
