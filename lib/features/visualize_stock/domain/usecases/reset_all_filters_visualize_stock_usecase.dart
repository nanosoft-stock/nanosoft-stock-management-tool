import 'package:stock_management_tool/core/constants/enums.dart';
import 'package:stock_management_tool/core/usecase/usecase.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/repositories/visualize_stock_repository.dart';

class ResetAllFiltersVisualizeStockUseCase extends UseCase {
  ResetAllFiltersVisualizeStockUseCase(this._visualizeStockRepository);

  final VisualizeStockRepository _visualizeStockRepository;

  @override
  Future call({params}) async {
    Map<String, dynamic> visualizeStock = params["visualize_stock"];

    visualizeStock["stocks"] = _visualizeStockRepository.getAllStocks();

    visualizeStock["filters"].forEach((k, v) {
      v["sort"] = k != "date" ? Sort.none : Sort.desc;
      v["filter_by"] = "";
      v["filter_value"] = "";
      v["search_value"] = "";
      v["all_selected"] = true;
      v.addAll(_visualizeStockRepository.getUniqueValues(
          field: v["field"], stocks: visualizeStock["stocks"]));
    });

    return visualizeStock;
  }
}
