import 'package:stock_management_tool/features/add_new_product/domain/entities/product_input_field_entity.dart';

class ProductInputFieldModel extends ProductInputFieldEntity {
  const ProductInputFieldModel({
    required super.uid,
    required super.field,
    required super.datatype,
    required super.isWithSKU,
    required super.isTitleCase,
    required super.items,
    required super.textValue,
  });

  factory ProductInputFieldModel.fromJson(Map<String, dynamic> map) {
    return ProductInputFieldModel(
      uid: map['uid'],
      field: map['field'],
      datatype: map['datatype'],
      isWithSKU: map['isWithSKU'],
      isTitleCase: map['isTitleCase'],
      items: map['items'] ?? [],
      textValue: "",
    );
  }

  ProductInputFieldModel copyWith({
    String? uid,
    String? field,
    String? datatype,
    bool? isWithSKU,
    bool? isTitleCase,
    List<dynamic>? items,
    String? textValue,
  }) {
    return ProductInputFieldModel(
      uid: uid ?? this.uid,
      field: field ?? this.field,
      datatype: datatype ?? this.datatype,
      isWithSKU: isWithSKU ?? this.isWithSKU,
      isTitleCase: isTitleCase ?? this.isTitleCase,
      items: items?.toList() ?? this.items,
      textValue: textValue ?? this.textValue,
    );
  }
}
