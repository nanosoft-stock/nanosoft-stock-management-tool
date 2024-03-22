import 'package:stock_management_tool/models/category_based_predefined_data.dart';
import 'package:stock_management_tool/services/firebase_rest_api.dart';

class AllPredefinedData {
  AllPredefinedData();

  Map data = {};

  Future<Map> fetchData() async {

    final all_categories = (await FirebaseRestApi().getDocuments(path: "category_list")).map((e) => {"category": e["category"]["stringValue"]}).toList();

    all_categories.map((e) => CategoryBasedPredefinedData(category: e["category"]));
    print(all_categories);

    for (var e in all_categories) {
      data[e["category"]] = await CategoryBasedPredefinedData(category: e["category"]).fetchData();
      print(e["category"]);
    }

    return data;
  }

}