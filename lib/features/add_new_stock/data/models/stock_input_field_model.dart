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
    required super.order,
    required super.isDisabled,
    required super.textValue,
  });

  factory StockInputFieldModel.fromJson(Map<String, dynamic> json) {
    return StockInputFieldModel(
      field: json["field"],
      category: json["category"],
      datatype: json["datatype"],
      inSku: json["in_sku"],
      isBackground: json["is_background"],
      isLockable: json["is_lockable"],
      items: json["items"],
      nameCase: json["name_case"],
      valueCase: json["value_case"],
      order: json["order"],
      isDisabled: json["is_disabled"] ?? false,
      textValue: json["text_value"] ?? "",
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
    int? order,
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
      order: order ?? this.order,
      isDisabled: isDisabled ?? this.isDisabled,
      textValue: textValue ?? this.textValue,
    );
  }

  Map<String, dynamic> toJson() {
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
      "order": order,
      "is_disabled": isDisabled,
      "text_value": textValue,
    };
  }
}
