import 'package:stock_management_tool/services/firebase_rest_api.dart';

class FieldsModel {
  FieldsModel({required this.category, required this.categoryDoc});

  String category;
  String categoryDoc;
  List items = [];

  Future<List> fetchItems() async {
    items = await FirebaseRestApi().getDocuments(path: "category_list/$categoryDoc/fields");
    items = items.map((e) {
      Map data = {
        "field": e["field"]["stringValue"],
        "datatype": e["datatype"]["stringValue"],
        "lockable": e["lockable"]["booleanValue"],
        "isWithSKU": e["isWithSKU"]["booleanValue"],
        "order": int.parse(e["order"]["integerValue"]),
      };
      if (e["items"] != null) {
        data["items"] = e["items"]["arrayValue"]["values"].map((e) => e["stringValue"]).toList();
      }
      return data;
    }).toList();
    items.sort((a, b) => a["order"].compareTo(b["order"]));
    return items;
  }
}
