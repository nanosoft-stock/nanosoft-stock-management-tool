abstract class StockRepository {
  List<Map<String, dynamic>> getInitialInputFields();

  List<Map<String, dynamic>> getCategoryBasedInputFields(
      {required String category});

  Map<String, dynamic> getProductDescription(
      {required String category, required String sku});

  String getWarehouseLocationId({required String containerId});

  Future<void> addNewStock({required List fields});
}
