import 'package:stock_management_tool/features/visualize_stock/domain/entities/stock_entity.dart';

class StockModel extends StockEntity {
  const StockModel({
    required super.uid,
    required super.date,
    required super.category,
    required super.itemId,
    required super.containerId,
    required super.warehouseLocationId,
    required super.fields,
    required super.values,
  });

  factory StockModel.fromJson(Map<String, dynamic> json) {
    return StockModel(
      uid: json["uid"],
      date: json["date"],
      category: json["category"] ?? "",
      itemId: json["item id"] ?? "",
      containerId: json["container id"] ?? "",
      warehouseLocationId: json["warehouse location id"] ?? "",
      fields: json["fields"] ?? [],
      values: json["values"] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    for (int i = 0; i < fields.length; i++) {
      json[fields[i]] = values[i];
    }

    return {
      "uid": uid,
      "date": date,
      "category": category,
      "item id": itemId,
      "container id": containerId,
      "warehouse location id": warehouseLocationId,
      ...json,
    };
  }

  Map<String, dynamic> toPartialJson() {
    return {
      "uid": uid,
      "date": date,
      "category": category,
      "item id": itemId,
      "container id": containerId,
      "warehouse location id": warehouseLocationId,
      "fields": fields,
      "values": values,
    };
  }

  StockModel copyWith({
    String? uid,
    DateTime? date,
    String? category,
    String? itemId,
    String? containerId,
    String? warehouseLocationId,
    List<String>? fields,
    List<String>? values,
  }) {
    return StockModel(
      uid: uid ?? this.uid,
      date: date ?? this.date,
      category: category ?? this.category,
      itemId: itemId ?? this.itemId,
      containerId: containerId ?? this.containerId,
      warehouseLocationId: warehouseLocationId ?? this.warehouseLocationId,
      fields: fields ?? this.fields,
      values: values ?? this.values,
    );
  }
}
