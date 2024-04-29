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

    locatedItems[index]["selected_ids_details"] = await _locateStockRepository.getIdSpecificData(
      searchBy: locatedItems[index]["search_by"],
      selectedIds: selectedIds,
    );

    String searchBy = locatedItems[index]["search_by"];

    if (searchBy != "Item Id") {
      List uniqueItems = [];

      locatedItems[index]["selected_ids"].forEach((element) {
        Map data = {};

        if (searchBy == "Container Id") {
          data = {
            ...locatedItems[index]["selected_ids_details"]
                .firstWhere((ele) => ele["container_id"] == element, orElse: () => {})
          };
        } else if (searchBy == "Warehouse Location Id") {
          data = {
            ...locatedItems[index]["selected_ids_details"]
                .firstWhere((ele) => ele["warehouse_location_id"] == element, orElse: () => {})
          };
        }

        if (data.isNotEmpty) {
          data.remove("id");
          data["is_selected"] = CheckBoxState.empty;
          uniqueItems.add(data);
        }
      });

      locatedItems[index]["unique_ids_details"] = uniqueItems;
    }

    return locatedItems;
  }
}
