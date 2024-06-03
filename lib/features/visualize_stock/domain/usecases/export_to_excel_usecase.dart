import 'package:stock_management_tool/core/usecase/usecase.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/repositories/visualize_stock_repository.dart';

class ExportToExcelUseCase extends UseCase {
  ExportToExcelUseCase(this._visualizeStockRepository);

  final VisualizeStockRepository _visualizeStockRepository;

  @override
  Future call({params}) {
    Map<String, dynamic> visualizeStock = params["visualize_stock"];

    List fields = visualizeStock["fields"]
        .where((e) => visualizeStock["show_fields"].contains(e.field) as bool)
        .toList();

    return _visualizeStockRepository.exportToExcel(
        fields: fields, stocks: visualizeStock["stocks"]);
  }
}
