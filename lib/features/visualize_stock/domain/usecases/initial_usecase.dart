import 'package:stock_management_tool/core/usecase/usecase.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/repositories/visualize_stock_repository.dart';

class InitialVisualizeStockUseCase extends UseCase {
  InitialVisualizeStockUseCase(this._visualizeStockRepository);

  final VisualizeStockRepository _visualizeStockRepository;

  @override
  Future call({params}) async {
    Map<String, dynamic> visualizeStock = {};

    visualizeStock["fields"] = _visualizeStockRepository.getAllFields();
    visualizeStock["stocks"] = _visualizeStockRepository.getAllStocks();
    visualizeStock["filter"] = visualizeStock["fields"].map((e) => {}).toList();

    return visualizeStock;
  }
}
