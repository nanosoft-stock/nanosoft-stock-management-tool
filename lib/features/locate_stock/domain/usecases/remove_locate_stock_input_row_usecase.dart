import 'package:stock_management_tool/core/usecase/usecase.dart';

class RemoveLocateStockInputRowUseCase extends UseCase {
  RemoveLocateStockInputRowUseCase();

  @override
  Future call({params}) async {
    int index = params["index"];
    List<Map<String, dynamic>> locatedItems = params["located items"];
    locatedItems.removeAt(index);

    return locatedItems;
  }
}
