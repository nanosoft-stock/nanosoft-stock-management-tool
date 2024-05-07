import 'package:stock_management_tool/core/usecase/usecase.dart';

class ChooseIdsUseCase extends UseCase {
  ChooseIdsUseCase();

  @override
  Future call({params}) async {
    Map<String, dynamic> locatedStock = params["located_stock"];

    locatedStock["layers"].add("multiple_search_selection_overlay");

    return locatedStock;
  }
}
