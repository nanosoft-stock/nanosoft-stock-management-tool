import 'package:stock_management_tool/constants/constants.dart';
import 'package:stock_management_tool/models/category_based_predefined_data.dart';
import 'package:stock_management_tool/services/firebase_rest_api.dart';
import 'package:stock_management_tool/services/firestore.dart';

class AllPredefinedData {
  static Map data = {};

  Future<Map> fetchData() async {
    if (kIsDesktop) {
      data["categories"] = (await FirebaseRestApi().getDocuments(path: "category_list"))
          .map((e) => e["category"]["stringValue"])
          .toList();

      for (var e in data["categories"]) {
        data[e] = await CategoryBasedPredefinedData(category: e).fetchData();
      }
    } else {
      data["categories"] = (await Firestore().getDocuments(path: "category_list"))
          .map((e) => e["category"])
          .toList();
      for (var e in data["categories"]) {
        data[e] = await CategoryBasedPredefinedData(category: e).fetchData();
      }
    }

    return data;
  }
}
