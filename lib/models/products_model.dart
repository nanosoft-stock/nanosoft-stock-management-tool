import 'package:stock_management_tool/constants/constants.dart';
import 'package:stock_management_tool/injection_container.dart';
import 'package:stock_management_tool/services/firestore.dart';

class ProductsModel {
  ProductsModel({required this.category, required this.categoryDoc});

  String category;
  String categoryDoc;
  List items = [];

  Future<List> fetchItems() async {
    items = await sl.get<Firestore>().getDocuments(path: "category_list/$categoryDoc/product_list");

    if (kIsDesktop) {
      items = items
          .map((element) => element
              .map((field, value) => MapEntry(field, value.values.first))
              .cast<String, dynamic>())
          .toList();
    }

    return items;
  }
}
