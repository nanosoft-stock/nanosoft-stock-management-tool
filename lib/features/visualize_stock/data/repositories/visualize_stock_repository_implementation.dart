import 'package:stock_management_tool/features/visualize_stock/data/models/stock_field_model.dart';
import 'package:stock_management_tool/features/visualize_stock/data/models/stock_model.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/repositories/visualize_stock_repository.dart';
import 'package:stock_management_tool/injection_container.dart';
import 'package:stock_management_tool/objectbox.dart';

class VisualizeStockRepositoryImplementation implements VisualizeStockRepository {
  final ObjectBox _objectBox = sl.get<ObjectBox>();

  @override
  Future<List<StockFieldModel>> getAllFields() async {
    List fields = _objectBox.getInputFields().map((e) => e.toJson()).toList();

    return fields.map((e) => StockFieldModel.fromJson(e)).toSet().toList();
  }

  @override
  Future<List<Map<String, dynamic>>> getAllStocks() async {
    List stocks = _objectBox.getStocks().map((e) => e.toJson()).toList();

    return stocks.map((e) => StockModel.fromJson(e).toJson()).toList();
  }
}
