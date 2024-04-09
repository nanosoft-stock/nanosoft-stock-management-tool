import 'package:stock_management_tool/features/visualize_stock/domain/entities/stock_field_entity.dart';

abstract class VisualizeStockRepository {
  Future<List<StockFieldEntity>> getAllFields();

  Future<List<Map<String, dynamic>>> getAllStocks();
}
