import 'package:objectbox/objectbox.dart';

@Entity()
class ProductObjectBoxModel {
  ProductObjectBoxModel({
    this.id = 0,
    this.uid,
    this.category,
    this.sku,
    this.fields,
    this.values,
  });

  @Id()
  int id;

  String? uid;
  String? category;
  String? sku;
  List<String>? fields;
  List<String>? values;

  factory ProductObjectBoxModel.fromJson(Map json) {
    return ProductObjectBoxModel(
      uid: json["uid"],
      category: json["category"],
      sku: json["sku"],
      fields: json["fields"],
      values: json["values"],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    for (int i = 0; i < fields!.length; i++) {
      json[fields![i]] = values?[i] ?? "";
    }

    return {
      "uid": uid,
      "category": category,
      "sku": sku,
      "fields": fields,
      "values": values,
      ...json
    };
  }

  @override
  String toString() {
    return "ProductModel(id:$id, uid:$uid, category:$category, sku:$sku, fields:$fields, values:$values)";
  }
}
