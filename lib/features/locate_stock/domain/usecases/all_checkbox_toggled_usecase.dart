import 'package:stock_management_tool/constants/enums.dart';
import 'package:stock_management_tool/core/usecase/usecase.dart';

class AllCheckBoxToggledUseCase extends UseCase {
  AllCheckBoxToggledUseCase();

  @override
  Future call({params}) async {
    int index = params["index"];
    CheckBoxState state = params["state"];
    List<Map<String, dynamic>> locatedItems = params["located_items"];

    locatedItems[index]["selected_ids_details"].forEach((element) {
      element["is_selected"] = state;
    });

    if (locatedItems[index]["search_by"] != "Item Id") {
      locatedItems[index]["unique_ids_details"].forEach((element) {
        element["is_selected"] = state;
      });
    }

    return locatedItems;
  }
}
