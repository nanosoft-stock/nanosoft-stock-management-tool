import 'dart:convert';
import 'package:hive/hive.dart';

part 'container_hive_model.g.dart';

@HiveType(typeId: 3)
class ContainerHiveModel {
  ContainerHiveModel({
    this.containerId,
    this.warehouseLocationId,
    this.status,
  });

  @HiveField(0)
  String? containerId;

  @HiveField(1)
  String? warehouseLocationId;

  @HiveField(2)
  String? status;

  ContainerHiveModel copyWith({
    String? containerId,
    String? warehouseLocationId,
    String? status,
  }) {
    return ContainerHiveModel(
      containerId: containerId ?? this.containerId,
      warehouseLocationId: warehouseLocationId ?? this.warehouseLocationId,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'container_id': containerId,
      'warehouse_location_id': warehouseLocationId,
      'status': status,
    };
  }

  factory ContainerHiveModel.fromMap(Map<String, dynamic> map) {
    return ContainerHiveModel(
      containerId: (map['container_id'] as String?) ?? "",
      warehouseLocationId: (map['warehouse_location_id'] as String?) ?? "",
      status: (map['status'] as String?) ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory ContainerHiveModel.fromJson(String source) =>
      ContainerHiveModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'ContainerHiveModel(containerId: $containerId, warehouseLocationId: $warehouseLocationId, status: $status)';
}
