import 'package:stock_management_tool/core/constants/enums.dart';

abstract class VisualizeStockRepository {
  void listenToCloudDataChange(
      {required Map visualizeStock, required Function(Map) onChange});

  List<String> getAllFields();

  List<Map<String, dynamic>> getAllStocks();

  List<Map<String, dynamic>> sortStocks(
      {required String field, required Sort sort, required List stocks});

  int compareWithBlank(sort, a, b);

  Map<String, dynamic> getInitialFilters(
      {required List fields, required List stocks});

  Map<String, dynamic> getUniqueValues(
      {required String field, required List stocks});

  Map<String, dynamic> getFilterByValuesByDatatype({required List values});

  List<Map<String, dynamic>> getFilteredStocks({required Map filters});

  Future<void> importFromExcel();

  Future<void> exportToExcel({required List fields, required List stocks});
}
