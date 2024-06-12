import 'package:stock_management_tool/core/usecase/usecase.dart';

class ExpandCompletedMovesItemUseCase extends UseCase {
  ExpandCompletedMovesItemUseCase();

  @override
  Future call({params}) async {
    int index = params["index"];
    int i = params["i"];
    bool isExpanded = params["is_expanded"];
    Map<String, dynamic> locatedStock = params["located_stock"];

    List keys = locatedStock["completed_state_items"].keys.toList();

    locatedStock["completed_state_items"][keys[index]][i]["is_expanded"] =
        isExpanded;

    return locatedStock;
  }
}
