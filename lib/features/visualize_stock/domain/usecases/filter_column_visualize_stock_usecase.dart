import 'package:stock_management_tool/core/usecase/usecase.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/repositories/visualize_stock_repository.dart';

class FilterColumnVisualizeStockUseCase extends UseCase {
  FilterColumnVisualizeStockUseCase(this._visualizeStockRepository);

  final VisualizeStockRepository _visualizeStockRepository;

  @override
  Future call({params}) async {
    Map<String, dynamic> visualizeStock = params["visualize_stock"];

    visualizeStock["stocks"] = _visualizeStockRepository.getFilteredStocks(
      filters: visualizeStock["filters"],
    );

    for (var filter in visualizeStock["filters"]) {
      List uniqueValues = visualizeStock["stocks"]
          .map((e) => e[filter["field"]])
          .toSet()
          .toList();

      filter["all_unique_values"].forEach((e) {
        if (uniqueValues.contains(e["title"])) {
          e["show"] = true;
        } else {
          e["show"] = false;
        }
      });

      bool? allSelected;

      if (filter["all_unique_values"]
          .where((e) => e["show"] == true)
          .every((e) => e["selected"] == true)) {
        allSelected = true;
      } else if (filter["all_unique_values"]
          .where((e) => e["show"] == true)
          .any((e) => e["selected"] == true)) {
        allSelected = null;
      } else {
        allSelected = false;
      }

      filter["all_selected"] = allSelected;
    }

    return visualizeStock;
  }
}
