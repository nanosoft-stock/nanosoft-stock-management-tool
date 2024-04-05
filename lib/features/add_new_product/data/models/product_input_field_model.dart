import 'package:stock_management_tool/features/add_new_product/domain/entities/product_input_field_entity.dart';

class ProductInputFieldModel extends ProductInputFieldEntity {
  ProductInputFieldModel({
    required super.field,
    required super.datatype,
    required super.isWithSKU,
    required super.isTitleCase,
    required super.items,
    super.textValue,
  });

  factory ProductInputFieldModel.fromJson(Map<String, dynamic> map) {
    return ProductInputFieldModel(
      field: map['field'],
      datatype: map['datatype'],
      isWithSKU: map['isWithSKU'],
      isTitleCase: map['isTitleCase'],
      items: map['items'] ?? [],
      textValue: "",
    );
  }
}
