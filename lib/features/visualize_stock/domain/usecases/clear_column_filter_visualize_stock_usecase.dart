import 'package:stock_management_tool/core/constants/enums.dart';
import 'package:stock_management_tool/core/usecase/usecase.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/repositories/visualize_stock_repository.dart';

class ClearColumnFilterVisualizeStockUseCase extends UseCase {
  ClearColumnFilterVisualizeStockUseCase(this._visualizeStockRepository);

  final VisualizeStockRepository _visualizeStockRepository;

  @override
  Future call({params}) async {
    String field = params["field"];
    Map<String, dynamic> visualizeStock = params["visualize_stock"];

    Map<String, dynamic> fieldFilter = visualizeStock["filters"][field];

    fieldFilter["filter_by"] = "";
    fieldFilter["filter_value"] = "";
    fieldFilter["search_value"] = "";
    fieldFilter["unique_values_details"].forEach((k, v) {
      v["selected"] = true;
    });

    visualizeStock["stocks"] = _visualizeStockRepository.getFilteredStocks(
        filters: visualizeStock["filters"]);

    visualizeStock["filters"].forEach((k, v) {
      List uniqueValues =
          visualizeStock["stocks"].map((e) => e[k]).toSet().toList();

      v["unique_values_details"].forEach((k1, v1) {
        if (uniqueValues.contains(k1)) {
          v1["show"] = true;
        } else {
          v1["show"] = false;
        }
      });

      v["unique_values"] = uniqueValues
        ..sort((a, b) =>
            _visualizeStockRepository.compareWithBlank(Sort.asc, a, b));

      bool? allSelected;

      if (fieldFilter["unique_values_details"]
          .values
          .where((e) => e["show"] == true)
          .every((e) => e["selected"] == true)) {
        allSelected = true;
      } else if (fieldFilter["unique_values_details"]
          .values
          .where((e) => e["show"] == true)
          .any((e) => e["selected"] == true)) {
        allSelected = null;
      } else {
        allSelected = false;
      }

      fieldFilter["all_selected"] = allSelected;
    });

    return visualizeStock;
  }
}
