import 'package:stock_management_tool/constants/enums.dart';
import 'package:stock_management_tool/core/usecase/usecase.dart';

class AllCheckBoxToggledUseCase extends UseCase {
  AllCheckBoxToggledUseCase();

  @override
  Future call({params}) async {
    int index = params["index"];
    CheckBoxState state = params["state"];
    List<Map<String, dynamic>> locatedItems = params["located_items"];

    Set ids = {};
    Set conIds = {};
    Set warehouseIds = {};

    locatedItems[index]["selected_ids_details"].forEach((element) {
      ids.add(element["id"]);
      conIds.add(element["container_id"]);
      warehouseIds.add(element["warehouse_location_id"]);
      element["is_selected"] = state;
    });

    locatedItems.forEach((element) {
      element["selected_ids_details"].forEach((ele) {
        if (ids.contains(ele["id"])) {
          ele["is_selected"] = state;
        }
      });

      if (element["search_by"] == "Container Id") {
        element["unique_ids_details"].forEach((ele) {
          if (conIds.contains(ele["container_id"])) {
            List affectedContainers = element["selected_ids_details"]
                .where((e) => e["container_id"] == ele["container_id"])
                .toList();

            CheckBoxState containerState;

            if (affectedContainers
                .every((e) => e["is_selected"] == CheckBoxState.all)) {
              containerState = CheckBoxState.all;
            } else if (affectedContainers
                .any((e) => e["is_selected"] == CheckBoxState.all)) {
              containerState = CheckBoxState.partial;
            } else {
              containerState = CheckBoxState.empty;
            }

            ele["is_selected"] = containerState;
          }
        });
      }

      if (element["search_by"] == "Warehouse Location Id") {
        element["unique_ids_details"].forEach((ele) {
          if (warehouseIds.contains(ele["warehouse_location_id"])) {
            List affectedLocations = element["selected_ids_details"]
                .where((e) =>
                    e["warehouse_location_id"] == ele["warehouse_location_id"])
                .toList();

            CheckBoxState warehouseState;

            if (affectedLocations
                .every((e) => e["is_selected"] == CheckBoxState.all)) {
              warehouseState = CheckBoxState.all;
            } else if (affectedLocations
                .any((e) => e["is_selected"] == CheckBoxState.all)) {
              warehouseState = CheckBoxState.partial;
            } else {
              warehouseState = CheckBoxState.empty;
            }

            ele["is_selected"] = warehouseState;
          }
        });
      }
    });

    if (locatedItems[index]["search_by"] != "Item Id") {
      locatedItems[index]["unique_ids_details"].forEach((element) {
        element["is_selected"] = state;
      });
    }

    return locatedItems;
  }
}
