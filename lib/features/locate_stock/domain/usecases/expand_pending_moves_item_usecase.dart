import 'package:stock_management_tool/core/usecase/usecase.dart';

class ExpandPendingMovesItemUseCase extends UseCase {
  ExpandPendingMovesItemUseCase();

  @override
  Future call({params}) async {
    int index = params["index"];
    bool isExpanded = params["is_expanded"];
    Map<String, dynamic> locatedStock = params["located_stock"];

    locatedStock["pending_state_items"][index]["is_expanded"] = isExpanded;

    return locatedStock;
  }
}
