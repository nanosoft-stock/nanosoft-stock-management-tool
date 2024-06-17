import 'package:stock_management_tool/features/add_new_product/domain/entities/product_input_field_entity.dart';

class ProductInputFieldModel extends ProductInputFieldEntity {
  const ProductInputFieldModel({
    required super.field,
    required super.datatype,
    required super.items,
    required super.nameCase,
    required super.valueCase,
    required super.order,
    required super.textValue,
  });

  factory ProductInputFieldModel.fromJson(Map<String, dynamic> json) {
    return ProductInputFieldModel(
      field: json["field"],
      datatype: json["datatype"],
      items: (json["items"] ?? []).cast<String>(),
      nameCase: json["name_case"],
      valueCase: json["value_case"],
      order: json["order"],
      textValue: "",
    );
  }

  ProductInputFieldModel copyWith({
    String? field,
    String? datatype,
    List<String>? items,
    String? nameCase,
    String? valueCase,
    int? order,
    String? textValue,
  }) {
    return ProductInputFieldModel(
      field: field ?? this.field,
      datatype: datatype ?? this.datatype,
      items: items ?? this.items,
      nameCase: nameCase ?? this.nameCase,
      valueCase: valueCase ?? this.valueCase,
      order: order ?? this.order,
      textValue: textValue ?? this.textValue,
    );
  }
}
