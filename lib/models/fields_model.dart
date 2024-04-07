import 'package:stock_management_tool/constants/constants.dart';
import 'package:stock_management_tool/injection_container.dart';
import 'package:stock_management_tool/services/firestore.dart';

class FieldsModel {
  FieldsModel({required this.category, required this.categoryDoc});

  String category;
  String categoryDoc;
  List items = [];

  Future<List> fetchItems() async {
    items = await sl.get<Firestore>().getDocuments(path: "category_list/$categoryDoc/fields");

    if (kIsDesktop) {
      items = items
          .map((element) => element
              .map((field, value) => MapEntry(field, value.values.first))
              .cast<String, dynamic>())
          .toList();

      for (var element in items) {
        if (element["items"] != null) {
          element["items"] = element["items"]["values"].map((e) => e["stringValue"]).toList();
        }
      }
    }

    items.sort(
        (a, b) => int.parse(a["order"].toString()).compareTo(int.parse(b["order"].toString())));

    return items;
  }
}
