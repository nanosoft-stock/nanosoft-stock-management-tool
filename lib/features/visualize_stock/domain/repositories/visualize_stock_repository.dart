import 'package:stock_management_tool/core/constants/enums.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/entities/stock_field_entity.dart';

abstract class VisualizeStockRepository {
  void listenToCloudDataChange(
      {required Map visualizeStock, required Function(Map) onChange});

  List<StockFieldEntity> getAllFields();

  List<Map<String, dynamic>> getAllStocks();

  List<Map<String, dynamic>> sortStocks(
      {required String field, required Sort sort, required List stocks});

  List<Map<String, dynamic>> getInitialFilters(
      {required List fields, required List stocks});

  List<Map<String, dynamic>> getUniqueValues(
      {required String field, required List stocks});

  Map<String, dynamic> getFilterByValuesByDatatype({required List values});

  List<Map<String, dynamic>> getFilteredStocks({required List filters});

  Future<void> importFromExcel();

  Future<void> exportToExcel({required List fields, required List stocks});
}
