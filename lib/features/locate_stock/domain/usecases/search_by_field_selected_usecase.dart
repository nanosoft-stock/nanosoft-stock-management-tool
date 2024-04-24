import 'package:stock_management_tool/core/usecase/usecase.dart';

class SearchByFieldSelectedUseCase extends UseCase {
  SearchByFieldSelectedUseCase();

  @override
  Future call({params}) async {
    int index = params["index"];
    String searchBy = params["search by"];
    List<Map<String, dynamic>> locatedItems = params["located items"];

    locatedItems[index]["search by"] = searchBy;
    print(searchBy);
    locatedItems[index]["all ids"] = [
      "901290",
      "901291",
      "901292",
      "901293",
      "901294",
      "901295"
    ];

    return locatedItems;
  }
}
