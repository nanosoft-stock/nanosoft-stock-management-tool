import 'package:stock_management_tool/core/usecase/usecase.dart';

class InitialLocateStockUseCase extends UseCase {
  InitialLocateStockUseCase();

  @override
  Future call({params}) async {
    List<Map<String, dynamic>> locatedItems = [];
    locatedItems.add({"search_by": ""});

    return locatedItems;
  }
}
