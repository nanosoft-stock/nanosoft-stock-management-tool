import 'package:stock_management_tool/constants/enums.dart';

abstract class LocateStockRepository {
  Map<String, dynamic> getAllIds();

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

  Future<List> getContainerIds({required String warehouseLocationId});

  Future<String> getWarehouseLocationId({required String containerId});

  Future<void> listenToCloudDataChange({
    required Map locatedStock,
    required Function(Map) onChange,
  });

  Future<void> moveItemsToPendingState({required Map selectedItems});
}
