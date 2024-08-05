import 'dart:convert';
import 'package:hive/hive.dart';

part 'stock_hive_model.g.dart';

@HiveType(typeId: 6)
class StockHiveModel {
  StockHiveModel({
    required this.date,
    this.category,
    this.sku,
    this.serialNumber,
    this.itemId,
    this.containerId,
    this.warehouseLocationId,
    this.supplierInfo,
    this.comments,
    this.username,
    this.specifications,
  });

  @HiveField(0)
  DateTime date;

  @HiveField(1)
  String? category;

  @HiveField(2)
  String? sku;

  @HiveField(3)
  String? serialNumber;

  @HiveField(4)
  String? itemId;

  @HiveField(5)
  String? containerId;

  @HiveField(6)
  String? warehouseLocationId;

  @HiveField(7)
  String? supplierInfo;

  @HiveField(8)
  String? comments;

  @HiveField(9)
  String? username;

  @HiveField(10)
  Map<String, dynamic>? specifications;

  StockHiveModel copyWith({
    DateTime? date,
    String? category,
    String? sku,
    String? serialNumber,
    String? itemId,
    String? containerId,
    String? warehouseLocationId,
    String? supplierInfo,
    String? comments,
    String? username,
    Map<String, dynamic>? specifications,
  }) {
    return StockHiveModel(
      date: date ?? this.date,
      category: category ?? this.category,
      sku: sku ?? this.sku,
      serialNumber: serialNumber ?? this.serialNumber,
      itemId: itemId ?? this.itemId,
      containerId: containerId ?? this.containerId,
      warehouseLocationId: warehouseLocationId ?? this.warehouseLocationId,
      supplierInfo: supplierInfo ?? this.supplierInfo,
      comments: comments ?? this.comments,
      username: username ?? this.username,
      specifications: specifications ?? this.specifications,
    );
  }

  Map<String, dynamic> toPartialMap() {
    return <String, dynamic>{
      'date': date,
      'category': category,
      'sku': sku,
      'serial_number': serialNumber,
      'item_id': itemId,
      'container_id': containerId,
      'warehouse_location_id': warehouseLocationId,
      'supplier_info': supplierInfo,
      'comments': comments,
      'username': username,
      'specifications': specifications,
    };
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'date': date,
      'category': category,
      'sku': sku,
      'serial_number': serialNumber,
      'item_id': itemId,
      'container_id': containerId,
      'warehouse_location_id': warehouseLocationId,
      'supplier_info': supplierInfo,
      'comments': comments,
      'username': username,
      ...specifications!,
    };
  }

  factory StockHiveModel.fromMap(Map<String, dynamic> map) {
    return StockHiveModel(
      date: DateTime.parse(map['date'] as String),
      category: (map['category'] as String?) ?? "",
      sku: (map['sku'] as String?) ?? "",
      serialNumber: (map['serial_number'] as String?) ?? "",
      itemId: (map['item_id'] as String?) ?? "",
      containerId: (map['container_id'] as String?) ?? "",
      warehouseLocationId: (map['warehouse_location_id'] as String?) ?? "",
      supplierInfo: (map['supplier_info'] as String?) ?? "",
      comments: (map['comments'] as String?) ?? "",
      username: (map['username'] as String?) ?? "",
      specifications: Map<String, dynamic>.from(
          (map['specifications'] as Map<String, dynamic>? ?? {})),
    );
  }

  String toJson() => json.encode(toMap());

  factory StockHiveModel.fromJson(String source) =>
      StockHiveModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'StockHiveModel(date: $date, category: $category, sku: $sku, serialNumber: $serialNumber, itemId: $itemId, containerId: $containerId, warehouseLocationId: $warehouseLocationId, supplierInfo: $supplierInfo, comments: $comments, username: $username, specifications: $specifications)';
  }
}
