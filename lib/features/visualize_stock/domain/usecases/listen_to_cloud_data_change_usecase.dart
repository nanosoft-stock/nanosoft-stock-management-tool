import 'package:stock_management_tool/core/usecase/usecase.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/repositories/visualize_stock_repository.dart';

class ListenToCloudDataChangeVisualizeStockUseCase extends UseCase {
  ListenToCloudDataChangeVisualizeStockUseCase(this._visualizeStockRepository);

  final VisualizeStockRepository _visualizeStockRepository;

  @override
  Future call({params}) async {
    return _visualizeStockRepository.listenToCloudDataChange(
        visualizeStock: params["visualize_stock"],
        onChange: params["on_change"]);
  }
}
