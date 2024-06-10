import 'package:stock_management_tool/core/usecase/usecase.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/repositories/visualize_stock_repository.dart';

class ResetAllFiltersVisualizeStockUseCase extends UseCase {
  ResetAllFiltersVisualizeStockUseCase(this._visualizeStockRepository);

  final VisualizeStockRepository _visualizeStockRepository;

  @override
  Future call({params}) async {
    Map<String, dynamic> visualizeStock = params["visualize_stock"];

    visualizeStock["stocks"] = _visualizeStockRepository.getAllStocks();

    visualizeStock["filters"].forEach((e) {
      e["filter_by"] = "";
      e["filter_value"] = "";
      e["search_value"] = "";
      e["all_selected"] = true;
      e["all_unique_values"] = _visualizeStockRepository.getUniqueValues(
          field: e["field"], stocks: visualizeStock["stocks"]);
    });

    return visualizeStock;
  }
}
