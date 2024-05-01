import 'package:stock_management_tool/constants/enums.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/entities/stock_field_entity.dart';

abstract class VisualizeStockRepository {
  Future<List<StockFieldEntity>> getAllFields();

  Future<List<Map<String, dynamic>>> getAllStocks();

  Future<List<StockFieldEntity>> sortFields({required String field, required Sort sort});

  Future<List<Map<String, dynamic>>> sortStocks({required String field, required Sort sort});

  Future<void> importFromExcel();

  Future<void> exportToExcel();

  Future listenToCloudDataChange({required Function() onChange});
}
