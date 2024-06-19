import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class StockObjectBoxModel {
  StockObjectBoxModel({
    this.id = 0,
    this.uid,
    required this.date,
    this.category,
    this.itemId,
    this.containerId,
    this.warehouseLocationId,
    this.fields,
    this.values,
  });

  @Id()
  int id;

  String? uid;

  @Property(type: PropertyType.date)
  DateTime date;

  String? category;
  String? itemId;
  String? containerId;
  String? warehouseLocationId;

  List<String>? fields;
  List<String>? values;

  factory StockObjectBoxModel.fromJson(Map json) {
    return StockObjectBoxModel(
      uid: json["uid"],
      date: json["date"].runtimeType == Timestamp
          ? json["date"].toDate()
          : DateTime.parse(json["date"]),
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
    for (int i = 0; i < fields!.length; i++) {
      json[fields![i]] = values?[i] ?? "";
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

  @override
  String toString() {
    return "StockModel(date: $date, uid: $uid, category: $category, itemId: $itemId, containerId: $containerId, warehouseLocationId: $warehouseLocationId, fields: $fields, values: $values)";
  }
}
