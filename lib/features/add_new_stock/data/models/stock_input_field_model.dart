import 'package:stock_management_tool/features/add_new_stock/domain/entities/stock_input_field_entity.dart';

class StockInputFieldModel extends StockInputFieldEntity {
  const StockInputFieldModel({
    required super.field,
    required super.category,
    required super.datatype,
    required super.inSku,
    required super.isBackground,
    required super.isLockable,
    required super.items,
    required super.nameCase,
    required super.valueCase,
    required super.displayOrder,
    required super.isDisabled,
    required super.textValue,
  });

  factory StockInputFieldModel.fromMap(Map<String, dynamic> map) {
    return StockInputFieldModel(
      field: map["field"],
      category: map["category"],
      datatype: map["datatype"],
      inSku: map["in_sku"],
      isBackground: map["is_background"],
      isLockable: map["is_lockable"],
      items: map["items"] ?? [],
      nameCase: map["name_case"],
      valueCase: map["value_case"],
      displayOrder: map["display_order"],
      isDisabled: map["is_disabled"] ?? false,
      textValue: map["text_value"] ?? "",
    );
  }

  StockInputFieldModel copyWith({
    String? field,
    String? category,
    String? datatype,
    bool? inSku,
    bool? isBackground,
    bool? isLockable,
    List<String>? items,
    String? nameCase,
    String? valueCase,
    int? displayOrder,
    bool? isDisabled,
    String? textValue,
  }) {
    return StockInputFieldModel(
      field: field ?? this.field,
      category: category ?? this.category,
      datatype: datatype ?? this.datatype,
      inSku: inSku ?? this.inSku,
      isBackground: isBackground ?? this.isBackground,
      isLockable: isLockable ?? this.isLockable,
      items: items ?? this.items,
      nameCase: nameCase ?? this.nameCase,
      valueCase: valueCase ?? this.valueCase,
      displayOrder: displayOrder ?? this.displayOrder,
      isDisabled: isDisabled ?? this.isDisabled,
      textValue: textValue ?? this.textValue,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "field": field,
      "category": category,
      "datatype": datatype,
      "in_sku": inSku,
      "is_background": isBackground,
      "is_lockable": isLockable,
      "items": items,
      "name_case": nameCase,
      "value_case": valueCase,
      "display_order": displayOrder,
      "is_disabled": isDisabled,
      "text_value": textValue,
    };
  }
}
