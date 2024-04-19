import 'package:stock_management_tool/core/usecase/usecase.dart';

class SearchByFieldSelectedUseCase extends UseCase {
  SearchByFieldSelectedUseCase();

  @override
  Future call({params}) async {
    int index = params["index"];
    String searchBy = params["search by"];
    List<Map<String, dynamic>> locatedItems = params["located items"];
    locatedItems[index]["search by"] = searchBy;

    return locatedItems;
  }
}
