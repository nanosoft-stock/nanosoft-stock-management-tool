import 'package:stock_management_tool/features/add_new_stock/domain/entities/stock_input_field_entity.dart';

abstract class StockRepository {
  Future<List<StockInputFieldEntity>> getInitialInputFields();

  Future<List<StockInputFieldEntity>> getCategoryBasedInputFields({required String category});

  Future<Map> getProductDescription({required category, required sku});

  Future addNewStock({required List fields});
}
