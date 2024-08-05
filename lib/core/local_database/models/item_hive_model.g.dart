// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ItemHiveModelAdapter extends TypeAdapter<ItemHiveModel> {
  @override
  final int typeId = 4;

  @override
  ItemHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ItemHiveModel(
      itemId: fields[0] as String?,
      status: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ItemHiveModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.itemId)
      ..writeByte(1)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItemHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
