import 'package:stock_management_tool/constants/constants.dart';
import 'package:stock_management_tool/services/firebase_rest_api.dart';
import 'package:stock_management_tool/services/firestore.dart';
import 'package:stock_management_tool/utility/string_casting_extension.dart';

class CategoryModel {
  static List items = [];

  void fetchItems() async {
    if (kIsDesktop) {
      items = await FirebaseRestApi().getDocuments(collection: "category_list");
      items =
          items.map((e) => {"category": e["category"]["stringValue"]}).toList();
    } else {
      items = await Firestore().getDocuments(collection: "category_list");
    }
    items = items.map((e) => e['category'].toString().toTitleCase()).toList();
    print(items);
  }
}
