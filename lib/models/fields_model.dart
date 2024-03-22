import 'package:stock_management_tool/services/firebase_rest_api.dart';

class FieldsModel {
  FieldsModel({required this.category, required this.categoryDoc});

  String category;
  String categoryDoc;
  List items = [];

  Future<List> fetchItems() async {
    items = await FirebaseRestApi()
        .getDocuments(path: "category_list/$categoryDoc/fields");
    items = items
        .map(
          (e) => {
            "field": e["field"]["stringValue"],
            "datatype": e["datatype"]["stringValue"],
            "lockable": e["lockable"]["booleanValue"],
            "isWithSKU": e["isWithSKU"]["booleanValue"],
          },
        )
        .toList();
    print(items);
    return items;
  }
}
