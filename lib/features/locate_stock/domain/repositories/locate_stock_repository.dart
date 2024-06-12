import 'package:stock_management_tool/core/constants/enums.dart';

abstract class LocateStockRepository {
  void listenToCloudDataChange({
    required Map locatedStock,
    required void Function(Map) onChange,
  });

  Map<String, dynamic> getAllIds();

  int compareWithBlank(sort, a, b);

  Map<String, dynamic> getInitialFilters();

  List<Map<String, dynamic>> getFilteredStocks({required Map filters});

  Map<String, dynamic> getChosenIdsDetails({
    required String searchBy,
    required List chosenIds,
    required List selectedItemIds,
  });

  CheckBoxState getCheckBoxState(
      {required String key, required String id, required List items});

  Map<String, dynamic> changeAllStockState({
    required Map locatedStock,
  });

  List<Map<String, dynamic>> getSelectedIdsDetails({
    required List selectedItemIds,
  });

  List getContainerIds({required String warehouseLocationId});

  String getWarehouseLocationId({required String containerId});

  Future<void> moveItemsToPendingState({required Map selectedItems});

  Map<String, dynamic> getAllPendingStateItems(
      Map<String, dynamic> pendingStateItems);

  Future<void> changeMoveStateToComplete({required List pendingItems});

  Future<void> cancelPendingMove({required List pendingItems});

  Map<String, dynamic> getAllCompletedStateItems();
}
