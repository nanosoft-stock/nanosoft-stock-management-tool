import 'package:objectbox/objectbox.dart';

@Entity()
class InputFieldsObjectBoxModel {
  InputFieldsObjectBoxModel({
    this.id = 0,
    required this.uid,
    required this.field,
    required this.datatype,
    required this.category,
    required this.isWithSKU,
    required this.isTitleCase,
    required this.isBg,
    required this.lockable,
    required this.order,
    this.items,
    this.textValue,
    this.locked,
    this.updateTime,
  });

  @Id()
  int id;

  String? uid;
  String? field;
  String? datatype;
  String? category;
  bool? isWithSKU;
  bool? isTitleCase;
  bool? isBg;
  bool? lockable;
  int? order;
  List<String>? items;
  String? textValue;
  bool? locked;

  @Property(type: PropertyType.date)
  DateTime? updateTime;

  factory InputFieldsObjectBoxModel.fromJson(Map json) {
    return InputFieldsObjectBoxModel(
      uid: json["uid"],
      field: json["field"],
      datatype: json["datatype"],
      category: json["category"],
      isWithSKU: json["isWithSKU"],
      isTitleCase: json["isTitleCase"],
      isBg: json["isBg"],
      lockable: json["lockable"],
      order: int.parse(json["order"].toString()),
      items: json["items"] != null ? List<String>.from(json["items"]) : null,
      updateTime: json["updateTime"],
      textValue: json["textValue"] ?? "",
      locked: json["locked"] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "field": field,
      "datatype": datatype,
      "category": category,
      "isWithSKU": isWithSKU,
      "isTitleCase": isTitleCase,
      "isBg": isBg,
      "lockable": lockable,
      "order": order,
      "items": items,
      "textValue": textValue,
      "locked": locked,
    };
  }

  @override
  String toString() {
    return "InputFieldsModel(id:$id, uid: $uid, field:$field, datatype:$datatype, category:$category, isWithSKU:$isWithSKU, isTitleCase:$isTitleCase, isBg:$isBg, lockable:$lockable, order:$order, items:$items, textValue:$textValue, locked:$locked, updateTime:$updateTime)";
  }
}
