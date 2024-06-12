import 'package:stock_management_tool/core/constants/enums.dart';
import 'package:stock_management_tool/core/usecase/usecase.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/repositories/visualize_stock_repository.dart';

class SearchValueChangedVisualizeStockUseCase extends UseCase {
  SearchValueChangedVisualizeStockUseCase(this._visualizeStockRepository);

  final VisualizeStockRepository _visualizeStockRepository;

  @override
  Future call({params}) async {
    String field = params["field"];
    String searchValue = params["search_value"].toLowerCase();
    Map<String, dynamic> visualizeStock = params["visualize_stock"];

    Map<String, dynamic> fieldFilter = visualizeStock["filters"][field];

    fieldFilter["search_value"] = searchValue;

    Map allUniqueValuesDetails = fieldFilter["unique_values_details"];
    List uniqueValues = [];

    allUniqueValuesDetails.forEach((k, v) {
      v["show"] =
          k.toString().toLowerCase().contains(searchValue) ? true : false;
      if (v["show"] == true) {
        uniqueValues.add(k);
      }
    });

    fieldFilter["unique_values_details"] = allUniqueValuesDetails;

    fieldFilter["unique_values"] = uniqueValues
      ..sort(
          (a, b) => _visualizeStockRepository.compareWithBlank(Sort.asc, a, b));

    return visualizeStock;
  }
}
