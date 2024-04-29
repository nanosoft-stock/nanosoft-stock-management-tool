import 'package:stock_management_tool/core/usecase/usecase.dart';

class ShowTableToggledUseCase extends UseCase {
  ShowTableToggledUseCase();

  @override
  Future call({params}) async {
    int index = params["index"];
    bool showTable = params["show_table"];
    List<Map<String, dynamic>> locatedItems = params["located_items"];

    locatedItems[index]["show_table"] = showTable;

    return locatedItems;
  }
}
