import 'package:stock_management_tool/core/usecase/usecase.dart';

class ExpandCompletedMovesItemUseCase extends UseCase {
  ExpandCompletedMovesItemUseCase();

  @override
  Future call({params}) async {
    int index = params["index"];
    bool isExpanded = params["is_expanded"];
    Map<String, dynamic> locatedStock = params["located_stock"];

    locatedStock["completed_state_items"][index]["is_expanded"] = isExpanded;

    return locatedStock;
  }
}
