abstract class StockRepository {
  void listenToCloudDataChange(
      {required List fields, required Function() onChange});

  List<Map<String, dynamic>> getInitialInputFields();

  Future<List<Map<String, dynamic>>> getCategoryBasedInputFields(
      {required String category});

  List<Map<String, dynamic>> getProductDescription(
      {required String category, required String sku, required List fields});

  String getWarehouseLocationId({required String containerId});

  Future<void> addNewStock({required List fields});
}
