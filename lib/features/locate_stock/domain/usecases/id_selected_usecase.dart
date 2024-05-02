import 'package:stock_management_tool/constants/enums.dart';
import 'package:stock_management_tool/core/usecase/usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/repositories/locate_stock_repository.dart';

class IdSelectedUseCase extends UseCase {
  IdSelectedUseCase(this._locateStockRepository);

  final LocateStockRepository _locateStockRepository;

  @override
  Future call({params}) async {
    int index = params["index"];
    List selectedIds = params["ids"];
    List<Map<String, dynamic>> locatedItems = params["located_items"];
    locatedItems[index]["selected_ids"] = selectedIds.toSet().toList();

    // locatedItems[index]["selected ids"] = selectedIds.map((e) => [
    //       {
    //         "id": "",
    //         "type": "",
    //         "warehouse locations": [
    //           {
    //             "warehouse location id": "",
    //           }
    //         ],
    //         "containers": [
    //           {
    //             "warehouse location id": "",
    //             "container id": "",
    //             "container history": [
    //               {
    //                 "date": "",
    //                 "movement type": "",
    //                 "user": "",
    //                 "new location": {
    //                   "warehouse location id": "",
    //                 },
    //               },
    //             ],
    //           }
    //         ],
    //         "items": [
    //           {
    //             "warehouse location id": "",
    //             "container id": "",
    //             "item id": "",
    //             "item history": [
    //               {
    //                 "date": "",
    //                 "movement type": "",
    //                 "user": "",
    //                 "new location": {
    //                   "warehouse location id": "",
    //                   "container id": "",
    //                 },
    //               }
    //             ]
    //           }
    //         ],
    //       },
    //     ]);

    // if (locatedItems[index]["search_by"] == "Item Id") {
    //   // For an Item
    //   for (var id in selectedIds) {
    //     return {
    //       "id": id,
    //       "type": locatedItems[index]["search_by"],
    //       "warehouse_location_id": "", // Get warehouse location id
    //       "container_id": "", // Get container id
    //       // "items": [id], // Get item id
    //     };
    //   }
    // } else if (locatedItems[index]["search_by"] == "Container Id") {
    //   // For a Container
    //   for (var id in selectedIds) {
    //     return {
    //       "id": id,
    //       "type": locatedItems[index]["search_by"],
    //       "warehouse_location_id": "", // Get warehouse location id
    //       // "containers": [id], // Get container id
    //       "items": [], // List all item ids in that container
    //     };
    //   }
    // } else if (locatedItems[index]["search_by"] == "Warehouse Location Id") {
    //   // For a Warehouse Location
    //   for (var id in selectedIds) {
    //     return {
    //       "id": id,
    //       "type": locatedItems[index]["search_by"],
    //       // "warehouse_locations": [id], // Get warehouse location id
    //       "containers": [], // List all containers ids in that warehouse location
    //       "items": [
    //         {
    //           "item_id": "",
    //           "container_id": "",
    //         },
    //       ], // List all item ids in that warehouse location
    //     };
    //   }
    // }

    locatedItems[index]["selected_ids_details"] =
        await _locateStockRepository.getIdSpecificData(
      searchBy: locatedItems[index]["search_by"],
      selectedIds: selectedIds,
    );

    String searchBy = locatedItems[index]["search_by"];

    // locatedItems[index]["selected_ids_details"].forEach((element) {
    //
    //   locatedItems.forEach((ele) {
    //     ele["selected_ids_details"].forEach((e) => {
    //       if (e["id"] == element["id"]) {
    //
    //       }
    //     });
    //   });
    // });

    Set allItemsIds = {};
    Set allContainerIds = {};
    Set allWarehouseIds = {};

    locatedItems[index]["selected_ids_details"].forEach((element) {
      allItemsIds.add(element["id"]);
      allContainerIds.add(element["container_id"]);
      allWarehouseIds.add(element["warehouse_location_id"]);
    });

    for (var itemId in allItemsIds) {
      for (var element in locatedItems) {
        for (var ele in element["selected_ids_details"]) {
          if (ele["id"] == itemId) {
            List items = locatedItems[index]["selected_ids_details"]
                .where((e) => e["id"] == itemId)
                .toList();
            for (var e in items) {
              e["is_selected"] = ele["is_selected"];
            }
            break;
          }
        }
        break;
      }
    }

    if (searchBy != "Item Id") {
      List uniqueItems = [];

      locatedItems[index]["selected_ids"].forEach((element) {
        Map data = {};

        CheckBoxState state = CheckBoxState.empty;

        if (searchBy == "Container Id") {
          data = {
            ...locatedItems[index]["selected_ids_details"].firstWhere(
                (ele) => ele["container_id"] == element,
                orElse: () => {})
          };

          data.remove("is_selected");

          List affectedContainers = locatedItems[index]["selected_ids_details"]
              .where((e) => e["container_id"] == element)
              .toList();

          if (affectedContainers
              .every((ele) => ele["is_selected"] == CheckBoxState.all)) {
            state = CheckBoxState.all;
          } else if (affectedContainers
              .any((ele) => ele["is_selected"] == CheckBoxState.all)) {
            state = CheckBoxState.partial;
          } else {
            state = CheckBoxState.empty;
          }
        } else if (searchBy == "Warehouse Location Id") {
          data = {
            ...locatedItems[index]["selected_ids_details"].firstWhere(
                (ele) => ele["warehouse_location_id"] == element,
                orElse: () => {})
          };

          data.remove("container_id");
          data.remove("is_selected");

          List affectedLocations = locatedItems[index]["selected_ids_details"]
              .where((e) => e["warehouse_location_id"] == element)
              .toList();

          if (affectedLocations
              .every((ele) => ele["is_selected"] == CheckBoxState.all)) {
            state = CheckBoxState.all;
          } else if (affectedLocations
              .any((ele) => ele["is_selected"] == CheckBoxState.all)) {
            state = CheckBoxState.partial;
          } else {
            state = CheckBoxState.empty;
          }
        }

        if (data.isNotEmpty) {
          data.remove("id");

          data["is_selected"] = state;
          uniqueItems.add(data);
        }
      });

      locatedItems[index]["unique_ids_details"] = uniqueItems;
    }

    return locatedItems;
  }
}
