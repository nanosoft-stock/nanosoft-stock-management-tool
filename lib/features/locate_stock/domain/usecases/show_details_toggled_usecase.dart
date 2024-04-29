import 'package:stock_management_tool/core/usecase/usecase.dart';

class ShowDetailsToggledUseCase extends UseCase {
  ShowDetailsToggledUseCase();

  @override
  Future call({params}) async {
    int index = params["index"];
    bool showDetails = params["show_details"];
    List<Map<String, dynamic>> locatedItems = params["located_items"];

    locatedItems[index]["show_details"] = showDetails;

    return locatedItems;
  }
}
