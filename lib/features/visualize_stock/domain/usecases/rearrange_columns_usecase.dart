import 'package:stock_management_tool/core/usecase/usecase.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/repositories/visualize_stock_repository.dart';

class RearrangeColumnsUseCase extends UseCase {
  RearrangeColumnsUseCase(this._visualizeStockRepository);

  final VisualizeStockRepository _visualizeStockRepository;

  @override
  Future call({params}) async {
    List fields = params["fields"];
    Map<String, dynamic> visualizeStock = params["visualize_stock"];

    List showFields = [];
    for (var field in fields) {
      if (visualizeStock["filters"][field]["show_column"] == true) {
        showFields.add(field);
      }
    }

    visualizeStock["fields"] = fields;
    visualizeStock["show_fields"] = showFields;

    await _visualizeStockRepository.updateUserColumns(fields: showFields);

    return visualizeStock;
  }
}
