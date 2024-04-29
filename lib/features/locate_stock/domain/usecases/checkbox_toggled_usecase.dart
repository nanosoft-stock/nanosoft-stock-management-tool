import 'package:stock_management_tool/constants/enums.dart';
import 'package:stock_management_tool/core/usecase/usecase.dart';

class CheckBoxToggledUseCase extends UseCase {
  CheckBoxToggledUseCase();

  @override
  Future call({params}) async {
    int index = params["index"];
    String id = params["id"];
    CheckBoxState state = params["state"];
    List<Map<String, dynamic>> locatedItems = params["located_items"];

    if (locatedItems[index]["show_details"]) {
      int itemIndex =
          locatedItems[index]["selected_ids_details"].indexWhere((element) => element["id"] == id);

      locatedItems[index]["selected_ids_details"][itemIndex]["is_selected"] = state;

      if (locatedItems[index]["search_by"] == "Container Id") {
        String containerId = locatedItems[index]["selected_ids_details"][itemIndex]["container_id"];

        List affectedContainers = locatedItems[index]["selected_ids_details"]
            .where((e) => e["container_id"] == containerId)
            .toList();

        print(affectedContainers);

        CheckBoxState containerState;

        if (affectedContainers.every((element) => element["is_selected"] == CheckBoxState.all)) {
          containerState = CheckBoxState.all;
        } else if (affectedContainers
            .any((element) => element["is_selected"] == CheckBoxState.all)) {
          containerState = CheckBoxState.partial;
        } else {
          containerState = CheckBoxState.empty;
        }

        locatedItems[index]["unique_ids_details"]
            .firstWhere((e) => e["container_id"] == containerId)["is_selected"] = containerState;
      } else if (locatedItems[index]["search_by"] == "Warehouse Location Id") {
        String warehouseLocationId =
            locatedItems[index]["selected_ids_details"][itemIndex]["warehouse_location_id"];

        List affectedLocations = locatedItems[index]["selected_ids_details"]
            .where((e) => e["warehouse_location_id"] == warehouseLocationId)
            .toList();

        CheckBoxState warehouseState;

        if (affectedLocations.every((element) => element["is_selected"] == CheckBoxState.all)) {
          warehouseState = CheckBoxState.all;
        } else if (affectedLocations
            .any((element) => element["is_selected"] == CheckBoxState.all)) {
          warehouseState = CheckBoxState.partial;
        } else {
          warehouseState = CheckBoxState.empty;
        }

        locatedItems[index]["unique_ids_details"].firstWhere(
                (e) => e["warehouse_location_id"] == warehouseLocationId)["is_selected"] =
            warehouseState;
      }
    } else {
      if (locatedItems[index]["search_by"] == "Container Id") {
        locatedItems[index]["selected_ids_details"].forEach((element) {
          if (element["container_id"] == id) {
            element["is_selected"] = state;
          }
        });
        locatedItems[index]["unique_ids_details"]
            .firstWhere((element) => element["container_id"] == id)["is_selected"] = state;
      } else if (locatedItems[index]["search_by"] == "Warehouse Location Id") {
        locatedItems[index]["selected_ids_details"].forEach((element) {
          if (element["warehouse_location_id"] == id) {
            element["is_selected"] = state;
          }
        });
        locatedItems[index]["unique_ids_details"]
            .firstWhere((element) => element["warehouse_location_id"] == id)["is_selected"] = state;
      }
    }

    return locatedItems;
  }
}
