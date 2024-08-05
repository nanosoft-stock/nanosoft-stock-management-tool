import 'dart:convert';
import 'package:hive/hive.dart';

part 'warehouse_location_hive_model.g.dart';

@HiveType(typeId: 2)
class WarehouseLocationHiveModel {
  WarehouseLocationHiveModel({
    this.warehouseLocationId,
  });

  @HiveField(0)
  String? warehouseLocationId;

  WarehouseLocationHiveModel copyWith({
    String? warehouseLocationId,
  }) {
    return WarehouseLocationHiveModel(
      warehouseLocationId: warehouseLocationId ?? this.warehouseLocationId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'warehouse_location_id': warehouseLocationId,
    };
  }

  factory WarehouseLocationHiveModel.fromMap(Map<String, dynamic> map) {
    return WarehouseLocationHiveModel(
      warehouseLocationId: map['warehouse_location_id'] as String? ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory WarehouseLocationHiveModel.fromJson(String source) =>
      WarehouseLocationHiveModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'WarehouseLocationHiveModel(warehouseLocationId: $warehouseLocationId)';
}
