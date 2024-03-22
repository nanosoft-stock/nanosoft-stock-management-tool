import 'package:stock_management_tool/services/firebase_rest_api.dart';

class DropdownFieldModel {
  DropdownFieldModel({
    required this.category,
    required this.categoryDoc,
  }); // required this.field, required this.fieldDoc});

  String category;
  String categoryDoc;

  // String field;
  // String fieldDoc;
  List items = [];

  Future<List> fetchItems() async {
    items = await FirebaseRestApi()
        .getDocuments(path: "category_list/$categoryDoc/drop_down_values/");
    items = items
        .map(
          (e) => {
            "field": e["field"]["stringValue"],
            "values": e["values"]["arrayValue"]["values"]
                .map((ele) => ele["stringValue"])
                .toList(),
          },
        )
        .toList();
    print(items);
    return items;
  }
}
