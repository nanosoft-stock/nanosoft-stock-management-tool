import 'package:stock_management_tool/core/usecase/usecase.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/repositories/visualize_stock_repository.dart';

class GetAllFieldsUseCase extends UseCase {
  GetAllFieldsUseCase(this._visualizeStockRepository);

  final VisualizeStockRepository _visualizeStockRepository;

  @override
  Future call({params}) {
    return _visualizeStockRepository.getAllFields();
  }
}