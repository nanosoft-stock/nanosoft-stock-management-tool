import 'package:stock_management_tool/features/add_new_stock/domain/entities/stock_input_field_entity.dart';

class StockInputFieldModel extends StockInputFieldEntity {
  const StockInputFieldModel({
    required super.uid,
    required super.field,
    required super.datatype,
    required super.lockable,
    required super.isWithSKU,
    required super.isTitleCase,
    required super.isBg,
    required super.order,
    required super.items,
    required super.textValue,
    required super.locked,
  });

  factory StockInputFieldModel.fromJson(Map<String, dynamic> map) {
    return StockInputFieldModel(
      uid: map['uid'],
      field: map['field'],
      datatype: map['datatype'],
      lockable: map['lockable'],
      isWithSKU: map['isWithSKU'],
      isTitleCase: map['isTitleCase'],
      isBg: map['isBg'],
      order: int.parse(map['order'].toString()),
      items: map['items'] ?? [],
      textValue: "",
      locked: false,
    );
  }

  StockInputFieldModel copyWith({
    String? uid,
    String? field,
    String? datatype,
    bool? lockable,
    bool? isWithSKU,
    bool? isTitleCase,
    bool? isBg,
    int? order,
    List<dynamic>? items,
    String? textValue,
    bool? locked,
  }) {
    return StockInputFieldModel(
      uid: uid ?? this.uid,
      field: field ?? this.field,
      datatype: datatype ?? this.datatype,
      lockable: lockable ?? this.lockable,
      isWithSKU: isWithSKU ?? this.isWithSKU,
      isTitleCase: isTitleCase ?? this.isTitleCase,
      isBg: isBg ?? this.isBg,
      order: order ?? this.order,
      items: items?.toList() ?? this.items,
      textValue: textValue ?? this.textValue,
      locked: locked ?? this.locked,
    );
  }
}
