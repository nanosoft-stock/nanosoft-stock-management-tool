import 'package:stock_management_tool/constants/constants.dart';
import 'package:stock_management_tool/services/firebase_rest_api.dart';
import 'package:stock_management_tool/services/firestore.dart';

class ProductsModel {
  ProductsModel({required this.category, required this.categoryDoc});

  String category;
  String categoryDoc;
  List items = [];

  Future<List> fetchItems() async {
    if (kIsDesktop) {
      items = await FirebaseRestApi().getDocuments(path: "category_list/$categoryDoc/product_list");

      items = items
          .map((element) => element
              .map((field, value) => MapEntry(field, value.values.first))
              .cast<String, dynamic>())
          .toList();
    } else {
      items = await Firestore().getDocuments(path: "category_list/$categoryDoc/product_list");
    }

    return items;
  }
}
