import 'package:stock_management_tool/core/constants/enums.dart';
import 'package:stock_management_tool/core/usecase/usecase.dart';
import 'package:stock_management_tool/features/locate_stock/domain/repositories/locate_stock_repository.dart';

class SelectAllCheckBoxToggledUseCase extends UseCase {
  SelectAllCheckBoxToggledUseCase(this._locateStockRepository);

  final LocateStockRepository _locateStockRepository;

  @override
  Future call({params}) async {
    int index = params["index"];
    CheckBoxState state = params["state"];
    Map<String, dynamic> locatedStock = params["located_stock"];

    List selectedItemIds = locatedStock["selected_item_ids"];
    List rowItems = locatedStock["rows"][index]["items"];
    List items = [];

    items = rowItems.map((e) => e["item_id"]).toList();

    if (state == CheckBoxState.all) {
      selectedItemIds.addAll(items);
    } else {
      for (var element in items) {
        selectedItemIds.remove(element);
      }
    }
    locatedStock["selected_item_ids"] = selectedItemIds.toSet().toList();

    return _locateStockRepository.changeAllStockState(
        locatedStock: locatedStock);
  }
}
