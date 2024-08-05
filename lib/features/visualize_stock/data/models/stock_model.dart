import 'package:stock_management_tool/features/visualize_stock/domain/entities/stock_entity.dart';

class StockModel extends StockEntity {
  const StockModel({
    super.date,
    super.category,
    super.sku,
    super.serialNumber,
    super.itemId,
    super.containerId,
    super.warehouseLocationId,
    super.supplierInfo,
    super.comments,
    super.username,
    super.specifications,
  });

  factory StockModel.fromMap(Map<String, dynamic> json) {
    return StockModel(
      date: json['date'],
      category: json['category'] ?? "",
      sku: json['sku'] ?? "",
      serialNumber: json['serial_number'] ?? "",
      itemId: json['item_id'] ?? "",
      containerId: json['container_id'] ?? "",
      warehouseLocationId: json['warehouse_location_id'] ?? "",
      supplierInfo: json['supplier_info'] ?? "",
      comments: json['comments'] ?? "",
      username: json['user'] ?? "",
      specifications: json['specifications'] ?? {},
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "date": date,
      "category": category,
      "sku": sku,
      "serial_number": serialNumber,
      "item_id": itemId,
      "container_id": containerId,
      "warehouse_location_id": warehouseLocationId,
      "supplier_info": supplierInfo,
      "comments": comments,
      "user": username,
      ...specifications ?? {},
    };
  }

  Map<String, dynamic> toPartialMap() {
    return {
      "date": date,
      "category": category,
      "sku": sku,
      "serial_number": serialNumber,
      "item_id": itemId,
      "container_id": containerId,
      "warehouse_location_id": warehouseLocationId,
      "supplier_info": supplierInfo,
      "comments": comments,
      "user": username,
      "specifications": specifications,
    };
  }

  StockModel copyWith({
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
    return StockModel(
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
}
