abstract class ProductRepository {
  void listenToCloudDataChange(
      {required List fields, required Function(List) onChange});

  List<Map<String, dynamic>> getInitialInputFields();

  List<Map<String, dynamic>> getCategoryBasedInputFields(
      {required String category, required String sku});

  Future<void> addNewProduct({required List fields});
}
