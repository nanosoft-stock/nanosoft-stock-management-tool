import 'package:stock_management_tool/constants/enums.dart';
import 'package:stock_management_tool/core/usecase/usecase.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/repositories/visualize_stock_repository.dart';

class SortVisualizeStockUseCase extends UseCase {
  SortVisualizeStockUseCase(this._visualizeStockRepository);

  final VisualizeStockRepository _visualizeStockRepository;

  @override
  Future call({params}) async {
    String field = params["field"];
    Sort sort = params["sort"];
    Map visualizeStock = params["visualize_stock"];

    visualizeStock["fields"] =
        _visualizeStockRepository.sortFields(field: field, sort: sort);
    visualizeStock["stocks"] = _visualizeStockRepository.sortStocks(
        field: field, sort: sort, stocks: visualizeStock["stocks"]);

    return visualizeStock;
  }
}
