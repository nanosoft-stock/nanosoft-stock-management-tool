import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'category_field_hive_model.g.dart';

@HiveType(typeId: 5)
class CategoryFieldHiveModel extends Equatable {
  const CategoryFieldHiveModel({
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
  final String? fieldUUID;

  @HiveField(1)
  final String? field;

  @HiveField(2)
  final String? category;

  @HiveField(3)
  final String? datatype;

  @HiveField(4)
  final bool? inSku;

  @HiveField(5)
  final bool? isBackground;

  @HiveField(6)
  final bool? isLockable;

  @HiveField(7)
  final String? nameCase;

  @HiveField(8)
  final String? valueCase;

  @HiveField(9)
  final int? displayOrder;

  @HiveField(10)
  final List<String>? items;

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
      displayOrder: (map['display_order'] as int?) ?? 1000,
      items: (map['items'] as List<String>?) ?? <String>[],
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryFieldHiveModel.fromJson(String source) =>
      CategoryFieldHiveModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      "CategoryFieldHiveModel(fieldUUID: $fieldUUID, field: $field, category: $category, datatype: $datatype, inSku: $inSku, isBackground: $isBackground, isLockable: $isLockable, nameCase: $nameCase, valueCase: $valueCase, displayOrder: $displayOrder, items: $items)";

  @override
  List<Object> get props {
    return [
      field!,
    ];
  }
}
