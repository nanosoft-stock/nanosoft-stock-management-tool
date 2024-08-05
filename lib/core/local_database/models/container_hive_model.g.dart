// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'container_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ContainerHiveModelAdapter extends TypeAdapter<ContainerHiveModel> {
  @override
  final int typeId = 3;

  @override
  ContainerHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ContainerHiveModel(
      containerId: fields[0] as String?,
      warehouseLocationId: fields[1] as String?,
      status: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ContainerHiveModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.containerId)
      ..writeByte(1)
      ..write(obj.warehouseLocationId)
      ..writeByte(2)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContainerHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
