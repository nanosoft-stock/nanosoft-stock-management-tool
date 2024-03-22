import 'package:stock_management_tool/constants/constants.dart';
import 'package:stock_management_tool/services/firebase_rest_api.dart';
import 'package:stock_management_tool/services/firestore.dart';
import 'package:stock_management_tool/utility/string_casting_extension.dart';

class CategoryModel {
  static List items = [];
  static List fields = [];

  Future<List> fetchItems() async {
    if (kIsDesktop) {
      items = await FirebaseRestApi().getDocuments(collection: "category_list");
      items =
          items.map((e) => {"category": e["category"]["stringValue"]}).toList();
    } else {
      items = await Firestore().getDocuments(collection: "category_list");
    }
    items = items.map((e) => e['category'].toString().toTitleCase()).toList();
    print(items);
    return items;
  }

  Future<List> fetchFields({required String value}) async {
    fields = [];
    if (kIsDesktop) {
      List result = await FirebaseRestApi().filterQuery(
        path: "",
        from: [
          {
            "collectionId": "category_list",
            "allDescendants": false,
          },
        ],
        where: {
          "fieldFilter": {
            "field": {
              "fieldPath": "category",
            },
            "op": "EQUAL",
            "value": {
              "stringValue": value,
            }
          },
        },
      );

      for (var res in result) {
        for (var element in await FirebaseRestApi()
            .getDocuments(collection: "category_list/$res/fields")) {
          fields.add(element);
        }
      }

      fields = fields
          .map(
            (e) => {
              "field": e["field"]["stringValue"],
              "datatype": e["datatype"]["stringValue"],
              "lockable": e["lockable"]["booleanValue"],
              "isWithSKU": e["isWithSKU"]["booleanValue"],
            },
          )
          .toList();
      print(fields);
    }
    return fields;
  }
}
