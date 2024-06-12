import 'package:stock_management_tool/core/usecase/usecase.dart';

class ExpandPendingMovesItemUseCase extends UseCase {
  ExpandPendingMovesItemUseCase();

  @override
  Future call({params}) async {
    int index = params["index"];
    int i = params["i"];
    bool isExpanded = params["is_expanded"];
    Map<String, dynamic> locatedStock = params["located_stock"];

    List keys = locatedStock["pending_state_items"].keys.toList();

    locatedStock["pending_state_items"][keys[index]][i]["is_expanded"] =
        isExpanded;

    return locatedStock;
  }
}
