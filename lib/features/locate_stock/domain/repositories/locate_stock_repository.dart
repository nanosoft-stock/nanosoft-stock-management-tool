import 'package:stock_management_tool/constants/enums.dart';

abstract class LocateStockRepository {
  void listenToCloudDataChange({
    required Map locatedStock,
    required Function(Map) onChange,
  });

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

  List<Map<String, dynamic>> getSelectedIdsDetails({
    required List selectedItemIds,
  });

  List getContainerIds({required String warehouseLocationId});

  String getWarehouseLocationId({required String containerId});

  Future<void> moveItemsToPendingState({required Map selectedItems});
}
