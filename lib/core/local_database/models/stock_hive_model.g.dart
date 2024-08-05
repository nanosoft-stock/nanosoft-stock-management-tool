// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StockHiveModelAdapter extends TypeAdapter<StockHiveModel> {
  @override
  final int typeId = 6;

  @override
  StockHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StockHiveModel(
      date: fields[0] as DateTime,
      category: fields[1] as String?,
      sku: fields[2] as String?,
      serialNumber: fields[3] as String?,
      itemId: fields[4] as String?,
      containerId: fields[5] as String?,
      warehouseLocationId: fields[6] as String?,
      supplierInfo: fields[7] as String?,
      comments: fields[8] as String?,
      username: fields[9] as String?,
      specifications: (fields[10] as Map?)?.cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, StockHiveModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.category)
      ..writeByte(2)
      ..write(obj.sku)
      ..writeByte(3)
      ..write(obj.serialNumber)
      ..writeByte(4)
      ..write(obj.itemId)
      ..writeByte(5)
      ..write(obj.containerId)
      ..writeByte(6)
      ..write(obj.warehouseLocationId)
      ..writeByte(7)
      ..write(obj.supplierInfo)
      ..writeByte(8)
      ..write(obj.comments)
      ..writeByte(9)
      ..write(obj.username)
      ..writeByte(10)
      ..write(obj.specifications);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StockHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
