import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'item_hive_model.g.dart';

@HiveType(typeId: 4)
class ItemHiveModel extends Equatable {
  const ItemHiveModel({
    this.itemId,
    this.status,
  });

  @HiveField(0)
  final String? itemId;

  @HiveField(1)
  final String? status;

  ItemHiveModel copyWith({
    String? itemId,
    String? status,
  }) {
    return ItemHiveModel(
      itemId: itemId ?? this.itemId,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'item_id': itemId,
      'status': status,
    };
  }

  factory ItemHiveModel.fromMap(Map<String, dynamic> map) {
    return ItemHiveModel(
      itemId: (map['item_id'] as String?) ?? "",
      status: (map['status'] as String?) ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory ItemHiveModel.fromJson(String source) =>
      ItemHiveModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => "ItemHiveModel(itemId: $itemId, status: $status)";

  @override
  List<Object> get props => [
        itemId!,
      ];
}