import 'package:stock_management_tool/core/constants/enums.dart';
import 'package:stock_management_tool/core/usecase/usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/repositories/locate_stock_repository.dart';

class SearchValueChangedLocateStockUseCase extends UseCase {
  SearchValueChangedLocateStockUseCase(this._locateStockRepository);

  final LocateStockRepository _locateStockRepository;

  @override
  Future call({params}) async {
    int index = params["index"];
    String field = params["field"];
    String searchValue = params["value"].toLowerCase();
    Map<String, dynamic> locatedStock = params["located_stock"];

    Map<String, dynamic> fieldFilter =
        locatedStock["rows"][index]["filters"][field];

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
      ..sort((a, b) => _locateStockRepository.compareWithBlank(Sort.asc, a, b));

    return locatedStock;
  }
}
