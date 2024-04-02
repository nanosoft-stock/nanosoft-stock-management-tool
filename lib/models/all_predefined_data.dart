import 'package:stock_management_tool/constants/constants.dart';
import 'package:stock_management_tool/models/category_based_predefined_data.dart';
import 'package:stock_management_tool/services/firestore.dart';

class AllPredefinedData {
  static Map data = {};

  Future<Map> fetchData() async {
    data["categories"] =
        (await Firestore().getDocuments(path: "category_list")).map((e) => e["category"]).toList();

    if (kIsDesktop) {
      data["categories"] = data["categories"].map((e) => e["stringValue"]).toList();
    }

    for (var e in data["categories"]) {
      data[e] = await CategoryBasedPredefinedData(category: e).fetchData();
    }

    return data;
  }
}
