import 'package:stock_management_tool/constants/enums.dart';
import 'package:stock_management_tool/features/visualize_stock/domain/entities/stock_field_entity.dart';

class StockFieldModel extends StockFieldEntity {
  const StockFieldModel({
    required super.uid,
    required super.field,
    required super.datatype,
    required super.lockable,
    required super.isWithSKU,
    required super.isTitleCase,
    required super.isBg,
    // required super.order,
    // required super.locked,
    // required super.sort,
  });

  factory StockFieldModel.fromJson(Map<String, dynamic> map) {
    return StockFieldModel(
      uid: map['uid'],
      field: map['field'],
      datatype: map['datatype'],
      lockable: map['lockable'],
      isWithSKU: map['isWithSKU'],
      isTitleCase: map['isTitleCase'],
      isBg: map['isBg'],
      // order: int.parse(map['order'].toString()),
      // locked: false,
      // sort: map["sort"] ?? Sort.none,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "field": field,
      "datatype": datatype,
      "lockable": lockable,
      "is_with_sku": isWithSKU,
      "is_title_case": isTitleCase,
      "is_bg": isBg,
      // "sort": sort,
    };
  }

  StockFieldModel copyWith({
    String? uid,
    String? field,
    String? datatype,
    bool? lockable,
    bool? isWithSKU,
    bool? isTitleCase,
    bool? isBg,
    // int? order,
    // bool? locked,
    // Sort? sort,
  }) {
    return StockFieldModel(
      uid: uid ?? this.uid,
      field: field ?? this.field,
      datatype: datatype ?? this.datatype,
      lockable: lockable ?? this.lockable,
      isWithSKU: isWithSKU ?? this.isWithSKU,
      isTitleCase: isTitleCase ?? this.isTitleCase,
      isBg: isBg ?? this.isBg,
      // order: order ?? this.order,
      // locked: locked ?? this.locked,
      // sort: sort ?? this.sort,
    );
  }
}
