import 'package:stock_management_tool/core/usecase/usecase.dart';

class AddNewLocateStockInputRowUseCase extends UseCase {
  AddNewLocateStockInputRowUseCase();

  @override
  Future call({params}) async {
    List<Map<String, dynamic>> locatedItems = params["located_items"];
    locatedItems.add({"search_by": ""});

    return locatedItems;
  }
}
