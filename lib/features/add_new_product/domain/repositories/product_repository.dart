import 'package:stock_management_tool/features/add_new_product/domain/entities/product_input_field_entity.dart';

abstract class ProductRepository {
  Future<List<ProductInputFieldEntity>> getInitialInputFields();

  Future<List<ProductInputFieldEntity>> getCategoryBasedInputFields(
      {required String category});

  Future addNewProduct({required List fields});
}
