import 'package:stock_management_tool/features/add_new_stock/domain/entities/stock_input_field_entity.dart';

abstract class StockRepository {
  List<Map<String, dynamic>> getInitialInputFields();

  List<Map<String, dynamic>> getCategoryBasedInputFields(
      {required String category});

  Map<String, dynamic> getProductDescription(
      {required String category, required String sku});

  String getWarehouseLocationId({required String containerId});

  Future<void> addNewStock({required List fields});
}
