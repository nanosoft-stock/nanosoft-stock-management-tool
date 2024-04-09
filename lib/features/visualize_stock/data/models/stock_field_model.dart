import 'package:stock_management_tool/features/visualize_stock/domain/entities/stock_field_entity.dart';

class StockFieldModel extends StockFieldEntity {
  const StockFieldModel({
    required super.field,
    required super.datatype,
    required super.lockable,
    required super.isWithSKU,
    required super.isTitleCase,
    required super.isBg,
    // required super.order,
    required super.locked,
  });

  factory StockFieldModel.fromJson(Map<String, dynamic> map) {
    return StockFieldModel(
      field: map['field'],
      datatype: map['datatype'],
      lockable: map['lockable'],
      isWithSKU: map['isWithSKU'],
      isTitleCase: map['isTitleCase'],
      isBg: map['isBg'],
      // order: int.parse(map['order'].toString()),
      locked: false,
    );
  }

  StockFieldModel copyWith({
    String? field,
    String? datatype,
    bool? lockable,
    bool? isWithSKU,
    bool? isTitleCase,
    bool? isBg,
    // int? order,
    bool? locked,
  }) {
    return StockFieldModel(
      field: field ?? this.field,
      datatype: datatype ?? this.datatype,
      lockable: lockable ?? this.lockable,
      isWithSKU: isWithSKU ?? this.isWithSKU,
      isTitleCase: isTitleCase ?? this.isTitleCase,
      isBg: isBg ?? this.isBg,
      // order: order ?? this.order,
      locked: locked ?? this.locked,
    );
  }
}
