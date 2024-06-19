import 'package:objectbox/objectbox.dart';

@Entity()
class InputFieldsObjectBoxModel {
  InputFieldsObjectBoxModel({
    this.id = 0,
    required this.uid,
    required this.field,
    required this.category,
    required this.datatype,
    required this.inSku,
    required this.isBackground,
    required this.isLockable,
    required this.items,
    required this.nameCase,
    required this.valueCase,
    required this.order,
  });

  @Id()
  int id;

  String? uid;
  String? field;
  String? category;
  String? datatype;
  bool? inSku;
  bool? isBackground;
  bool? isLockable;
  List<String>? items;
  String? nameCase;
  String? valueCase;
  int? order;

  factory InputFieldsObjectBoxModel.fromJson(Map json) {
    return InputFieldsObjectBoxModel(
      uid: json["uid"],
      field: json["field"],
      category: json["category"],
      datatype: json["datatype"],
      inSku: json["in_sku"],
      isBackground: json["is_background"],
      isLockable: json["is_lockable"],
      items: json["items"]?.cast<String>(),
      nameCase: json["name_case"],
      valueCase: json["value_case"],
      order: int.parse(json["order"].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "field": field,
      "category": category,
      "datatype": datatype,
      "in_sku": inSku,
      "is_background": isBackground,
      "is_lockable": isLockable,
      "items": items,
      "name_case": nameCase,
      "value_case": valueCase,
      "order": order,
    };
  }

  @override
  String toString() {
    return "InputFieldsModel(id:$id, uid: $uid, field:$field, datatype:$datatype, category:$category, in_sku:$inSku, is_background:$isBackground, is_lockable:$isLockable, items, $items, name_case:$nameCase, value_case: $valueCase, order:$order)";
  }
}
