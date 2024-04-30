import 'package:stock_management_tool/constants/enums.dart';
import 'package:stock_management_tool/core/usecase/usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/repositories/locate_stock_repository.dart';

class GetSelectedItemsUseCase extends UseCase {
  GetSelectedItemsUseCase(this._locateStockRepository);

  final LocateStockRepository _locateStockRepository;

  @override
  Future call({params}) async {
    List<Map<String, dynamic>> locatedItems = params["located_items"];

    Map<String, dynamic> data = {};

    Set itemIds = {};
    List<Map<String, dynamic>> selectedItems = [];

    for (var element in locatedItems) {
      if (element["selected_ids_details"] != null) {
        element["selected_ids_details"].forEach((ele) {
          if (ele["is_selected"] == CheckBoxState.all && !itemIds.contains(ele["id"])) {
            itemIds.add(ele["id"]);
            selectedItems.add({
              "id": ele["id"],
              "container_id": ele["container_id"],
              "warehouse_location_id": ele["warehouse_location_id"],
            });
          }
        });
      }
    }

    data["selected_items"] = selectedItems;

    if (selectedItems.isNotEmpty) {
      data["container_ids"] = await _locateStockRepository.getIds(searchBy: "Container Id");
      data["warehouse_location_ids"] =
          await _locateStockRepository.getIds(searchBy: "Warehouse Location Id");
      data["container_text"] = "";
      data["warehouse_location_text"] = "";
    }

    return data;
  }
}
