abstract class LocateStockRepository {
  Future<List> getIds({required String searchBy});

  Future<List> getIdSpecificData(
      {required String searchBy, required List selectedIds});

  Future<List> getContainerIds({required String warehouseLocationId});

  Future<String> getWarehouseLocationId({required String containerId});

  Future listenToCloudDataChange(
      {required List locatedItems,
      required Map selectedItems,
      required Function(List, Map) onChange});

  Future moveItemsToPendingState({required Map selectedItems});
}
