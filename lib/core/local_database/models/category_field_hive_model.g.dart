// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_field_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CategoryFieldHiveModelAdapter
    extends TypeAdapter<CategoryFieldHiveModel> {
  @override
  final int typeId = 5;

  @override
  CategoryFieldHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CategoryFieldHiveModel(
      fieldUUID: fields[0] as String?,
      field: fields[1] as String?,
      category: fields[2] as String?,
      datatype: fields[3] as String?,
      inSku: fields[4] as bool?,
      isBackground: fields[5] as bool?,
      isLockable: fields[6] as bool?,
      nameCase: fields[7] as String?,
      valueCase: fields[8] as String?,
      items: (fields[10] as List?)?.cast<String>(),
      displayOrder: fields[9] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, CategoryFieldHiveModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.fieldUUID)
      ..writeByte(1)
      ..write(obj.field)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.datatype)
      ..writeByte(4)
      ..write(obj.inSku)
      ..writeByte(5)
      ..write(obj.isBackground)
      ..writeByte(6)
      ..write(obj.isLockable)
      ..writeByte(7)
      ..write(obj.nameCase)
      ..writeByte(8)
      ..write(obj.valueCase)
      ..writeByte(10)
      ..write(obj.items)
      ..writeByte(9)
      ..write(obj.displayOrder);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryFieldHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
