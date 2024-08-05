import 'dart:convert';
import 'package:hive/hive.dart';

part 'category_field_hive_model.g.dart';

@HiveType(typeId: 5)
class CategoryFieldHiveModel {
  CategoryFieldHiveModel({
    this.fieldUUID,
    this.field,
    this.category,
    this.datatype,
    this.inSku,
    this.isBackground,
    this.isLockable,
    this.nameCase,
    this.valueCase,
    this.displayOrder,
    this.items,
  });

  @HiveField(0)
  String? fieldUUID;

  @HiveField(1)
  String? field;

  @HiveField(2)
  String? category;

  @HiveField(3)
  String? datatype;

  @HiveField(4)
  bool? inSku;

  @HiveField(5)
  bool? isBackground;

  @HiveField(6)
  bool? isLockable;

  @HiveField(7)
  String? nameCase;

  @HiveField(8)
  String? valueCase;

  @HiveField(9)
  int? displayOrder;

  @HiveField(10)
  List<String>? items;

  CategoryFieldHiveModel copyWith({
    String? fieldUUID,
    String? field,
    String? category,
    String? datatype,
    bool? inSku,
    bool? isBackground,
    bool? isLockable,
    String? nameCase,
    String? valueCase,
    int? displayOrder,
    List<String>? items,
  }) {
    return CategoryFieldHiveModel(
      fieldUUID: fieldUUID ?? this.fieldUUID,
      field: field ?? this.field,
      category: category ?? this.category,
      datatype: datatype ?? this.datatype,
      inSku: inSku ?? this.inSku,
      isBackground: isBackground ?? this.isBackground,
      isLockable: isLockable ?? this.isLockable,
      nameCase: nameCase ?? this.nameCase,
      valueCase: valueCase ?? this.valueCase,
      displayOrder: displayOrder ?? this.displayOrder,
      items: items ?? this.items,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'field_uuid': fieldUUID,
      'field': field,
      'category': category,
      'datatype': datatype,
      'in_sku': inSku,
      'is_background': isBackground,
      'is_lockable': isLockable,
      'name_case': nameCase,
      'value_case': valueCase,
      'display_order': displayOrder,
      'items': items,
    };
  }

  factory CategoryFieldHiveModel.fromMap(Map<String, dynamic> map) {
    return CategoryFieldHiveModel(
        fieldUUID: (map['field_uuid'] as String?) ?? "",
        field: (map['field'] as String?) ?? "",
        category: (map['category'] as String?) ?? "",
        datatype: (map['datatype'] as String?) ?? "",
        inSku: (map['in_sku'] as bool?) ?? false,
        isBackground: (map['is_background'] as bool?) ?? true,
        isLockable: (map['is_lockable'] as bool?) ?? true,
        nameCase: (map['name_case'] as String?) ?? "",
        valueCase: (map['value_case'] as String?) ?? "",
        displayOrder:
            map['display_order'] != null ? map['display_order'] as int : null,
        items: (map['items'] as List<String>?) ?? <String>[]);
  }

  String toJson() => json.encode(toMap());

  factory CategoryFieldHiveModel.fromJson(String source) =>
      CategoryFieldHiveModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CategoryFieldHiveModel(fieldUUID: $fieldUUID, field: $field, category: $category, datatype: $datatype, inSku: $inSku, isBackground: $isBackground, isLockable: $isLockable, nameCase: $nameCase, valueCase: $valueCase, displayOrder: $displayOrder, items: $items)';
  }
}
