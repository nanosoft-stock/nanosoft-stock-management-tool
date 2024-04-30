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

      locatedItems.forEach((element) {
        element["selected_ids_details"].forEach((ele) {
          if (ele["id"] == id) {
            ele["is_selected"] = state;
          }
        });
      });

      locatedItems.forEach((element) {
        if (element["search_by"] == "Container Id") {
          String containerId =
              locatedItems[index]["selected_ids_details"][itemIndex]["container_id"];
          List affectedContainers = element["selected_ids_details"]
              .where((e) => e["container_id"] == containerId)
              .toList();

          CheckBoxState containerState;

          if (affectedContainers.every((ele) => ele["is_selected"] == CheckBoxState.all)) {
            containerState = CheckBoxState.all;
          } else if (affectedContainers.any((ele) => ele["is_selected"] == CheckBoxState.all)) {
            containerState = CheckBoxState.partial;
          } else {
            containerState = CheckBoxState.empty;
          }

          List con =
              element["unique_ids_details"].where((e) => e["container_id"] == containerId).toList();
          con.forEach((element) {
            element["is_selected"] = containerState;
          });
        } else if (element["search_by"] == "Warehouse Location Id") {
          String warehouseLocationId =
              locatedItems[index]["selected_ids_details"][itemIndex]["warehouse_location_id"];

          List affectedLocations = element["selected_ids_details"]
              .where((e) => e["warehouse_location_id"] == warehouseLocationId)
              .toList();

          CheckBoxState warehouseState;

          if (affectedLocations.every((ele) => ele["is_selected"] == CheckBoxState.all)) {
            warehouseState = CheckBoxState.all;
          } else if (affectedLocations.any((ele) => ele["is_selected"] == CheckBoxState.all)) {
            warehouseState = CheckBoxState.partial;
          } else {
            warehouseState = CheckBoxState.empty;
          }

          List warehouse = element["unique_ids_details"]
              .where((e) => e["warehouse_location_id"] == warehouseLocationId)
              .toList();
          warehouse.forEach((element) {
            element["is_selected"] = warehouseState;
          });
        }
      });
    } else {
      if (locatedItems[index]["search_by"] == "Container Id") {
        locatedItems[index]["selected_ids_details"].forEach((element) {
          if (element["container_id"] == id) {
            element["is_selected"] = state;
          }
        });

        locatedItems.forEach((element) {
          element["selected_ids_details"].forEach((element) {
            if (element["container_id"] == id) {
              element["is_selected"] = state;
            }
          });
        });

        locatedItems.forEach((element) {
          if (element["search_by"] == "Container Id") {
            // String containerId = id;
            // locatedItems[index]["selected_ids_details"][itemIndex]["container_id"];
            List affectedContainers =
                element["selected_ids_details"].where((e) => e["container_id"] == id).toList();

            CheckBoxState containerState;

            if (affectedContainers.every((ele) => ele["is_selected"] == CheckBoxState.all)) {
              containerState = CheckBoxState.all;
            } else if (affectedContainers.any((ele) => ele["is_selected"] == CheckBoxState.all)) {
              containerState = CheckBoxState.partial;
            } else {
              containerState = CheckBoxState.empty;
            }

            List con = element["unique_ids_details"].where((e) => e["container_id"] == id).toList();
            con.forEach((element) {
              element["is_selected"] = containerState;
            });
          } else if (element["search_by"] == "Warehouse Location Id") {
            //   String warehouseLocationId =
            //   locatedItems[index]["selected_ids_details"].firstWhere((ele) => ele["container_id"] == id)["warehouse_location_id"];
            //
            //   List affectedLocations = element["selected_ids_details"]
            //       .where((e) => e["warehouse_location_id"] == warehouseLocationId)
            //       .toList();
            //
            //   CheckBoxState warehouseState;
            //
            //   if (affectedLocations.every((ele) => ele["is_selected"] == CheckBoxState.all)) {
            //     warehouseState = CheckBoxState.all;
            //   } else if (affectedLocations.any((ele) => ele["is_selected"] == CheckBoxState.all)) {
            //     warehouseState = CheckBoxState.partial;
            //   } else {
            //     warehouseState = CheckBoxState.empty;
            //   }
            //
            //   List warehouse = element["unique_ids_details"]
            //       .where((e) => e["warehouse_location_id"] == warehouseLocationId)
            //       .toList();
            //   warehouse.forEach((element) {
            //     element["is_selected"] = warehouseState;
            //   });
            // }

            // String warehouseLocationId =
            //   locatedItems[index]["selected_ids_details"].firstWhere((ele) => ele["container_id"] == id)["warehouse_location_id"];

            String warehouseLocationId = locatedItems[index]["selected_ids_details"]
                .firstWhere((ele) => ele["container_id"] == id)["warehouse_location_id"];

            List affectedLocations = element["selected_ids_details"]
                .where((e) => e["warehouse_location_id"] == warehouseLocationId)
                .toList();

            CheckBoxState warehouseState;

            if (affectedLocations.every((ele) => ele["is_selected"] == CheckBoxState.all)) {
              warehouseState = CheckBoxState.all;
            } else if (affectedLocations.any((ele) => ele["is_selected"] == CheckBoxState.all)) {
              warehouseState = CheckBoxState.partial;
            } else {
              warehouseState = CheckBoxState.empty;
            }

            List warehouse = element["unique_ids_details"]
                .where((e) => e["warehouse_location_id"] == warehouseLocationId)
                .toList();
            warehouse.forEach((element) {
              element["is_selected"] = warehouseState;
            });
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

        locatedItems.forEach((element) {
          element["selected_ids_details"].forEach((element) {
            if (element["warehouse_location_id"] == id) {
              element["is_selected"] = state;
            }
          });
        });

        locatedItems.forEach((element) {
          if (element["search_by"] == "Container Id") {
            List affectedContainers = element["selected_ids_details"]
                .where((e) => e["warehouse_location_id"] == id)
                .toList();

            CheckBoxState containerState;

            if (affectedContainers.every((ele) => ele["is_selected"] == CheckBoxState.all)) {
              containerState = CheckBoxState.all;
            } else if (affectedContainers.any((ele) => ele["is_selected"] == CheckBoxState.all)) {
              containerState = CheckBoxState.partial;
            } else {
              containerState = CheckBoxState.empty;
            }

            List con = element["unique_ids_details"]
                .where((e) => e["warehouse_location_id"] == id)
                .toList();
            con.forEach((element) {
              element["is_selected"] = containerState;
            });
          } else if (element["search_by"] == "Warehouse Location Id") {
            String warehouseLocationId = id;

            List affectedLocations = element["selected_ids_details"]
                .where((e) => e["warehouse_location_id"] == warehouseLocationId)
                .toList();

            CheckBoxState warehouseState;

            if (affectedLocations.every((ele) => ele["is_selected"] == CheckBoxState.all)) {
              warehouseState = CheckBoxState.all;
            } else if (affectedLocations.any((ele) => ele["is_selected"] == CheckBoxState.all)) {
              warehouseState = CheckBoxState.partial;
            } else {
              warehouseState = CheckBoxState.empty;
            }

            List warehouse = element["unique_ids_details"]
                .where((e) => e["warehouse_location_id"] == warehouseLocationId)
                .toList();
            warehouse.forEach((element) {
              element["is_selected"] = warehouseState;
            });
          }
        });

        locatedItems[index]["unique_ids_details"]
            .firstWhere((element) => element["warehouse_location_id"] == id)["is_selected"] = state;
      }
    }

    return locatedItems;
  }
}
