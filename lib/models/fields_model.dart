import 'package:stock_management_tool/constants/constants.dart';
import 'package:stock_management_tool/services/firebase_rest_api.dart';
import 'package:stock_management_tool/services/firestore.dart';

class FieldsModel {
  FieldsModel({required this.category, required this.categoryDoc});

  String category;
  String categoryDoc;
  List items = [];

  Future<List> fetchItems() async {
    if (kIsDesktop) {
      items = await FirebaseRestApi().getDocuments(path: "category_list/$categoryDoc/fields");

      items = items.map((e) {
        Map data = {
          "field": e["field"]["stringValue"],
          "datatype": e["datatype"]["stringValue"],
          "lockable": e["lockable"]["booleanValue"],
          "isWithSKU": e["isWithSKU"]["booleanValue"],
          "order": int.parse(
            e["order"]["integerValue"],
          ),
        };
        if (e["items"] != null) {
          data["items"] = e["items"]["arrayValue"]["values"].map((e) => e["stringValue"]).toList();
        }
        return data;
      }).toList();

      items.sort((a, b) => a["order"].compareTo(b["order"]));
    } else {
      items = await Firestore().getDocuments(path: "category_list/$categoryDoc/fields");
      items.sort((a, b) => a["order"].compareTo(b["order"]));
    }

    return items;
  }
}
