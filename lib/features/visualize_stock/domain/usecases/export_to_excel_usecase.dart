import 'package:stock_management_tool/core/usecase/usecase.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/repositories/visualize_stock_repository.dart';

class ExportToExcelUseCase extends UseCase {
  ExportToExcelUseCase(this._visualizeStockRepository);

  final VisualizeStockRepository _visualizeStockRepository;

  @override
  Future call({params}) async {
    Map<String, dynamic> visualizeStock = params["visualize_stock"];

    await _visualizeStockRepository.exportToExcel(
        fields: visualizeStock["show_fields"],
        stocks: visualizeStock["stocks"]);

    return visualizeStock;
  }
}
