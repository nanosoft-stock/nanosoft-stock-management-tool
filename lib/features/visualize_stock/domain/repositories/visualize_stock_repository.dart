import 'package:stock_management_tool/constants/enums.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/entities/stock_field_entity.dart';

abstract class VisualizeStockRepository {
  void listenToCloudDataChange({required Function() onChange});

  List<StockFieldEntity> getAllFields();

  List<Map<String, dynamic>> getAllStocks();

  List<Map<String, dynamic>> sortStocks(
      {required String field, required Sort sort, required List stocks});

  Future<void> importFromExcel();

  Future<void> exportToExcel();
}
