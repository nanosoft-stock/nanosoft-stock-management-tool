abstract class ProductRepository {
  List<Map<String, dynamic>> getInitialInputFields();

  List<Map<String, dynamic>> getCategoryBasedInputFields(
      {required String category, required String sku});

  Future<void> addNewProduct({required List fields});
}
