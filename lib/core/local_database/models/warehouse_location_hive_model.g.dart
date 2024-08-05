// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'warehouse_location_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WarehouseLocationHiveModelAdapter
    extends TypeAdapter<WarehouseLocationHiveModel> {
  @override
  final int typeId = 2;

  @override
  WarehouseLocationHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WarehouseLocationHiveModel(
      warehouseLocationId: fields[0] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, WarehouseLocationHiveModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.warehouseLocationId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WarehouseLocationHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
