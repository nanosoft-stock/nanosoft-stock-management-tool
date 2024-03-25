import 'package:stock_management_tool/models/fields_model.dart';
import 'package:stock_management_tool/models/products_model.dart';
import 'package:stock_management_tool/services/firebase_rest_api.dart';

class CategoryBasedPredefinedData {
  CategoryBasedPredefinedData({required this.category});

  String category;

  Map data = {};

  Future<Map> fetchData() async {
    final categoryDoc = (await FirebaseRestApi().filterQuery(
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
            "stringValue": category,
          }
        },
      },
    ))[0];

    data["categoryDoc"] = categoryDoc;

    data["fields"] = await FieldsModel(category: category, categoryDoc: categoryDoc).fetchItems();

    data["products"] =
        await ProductsModel(category: category, categoryDoc: categoryDoc).fetchItems();

    return data;
  }
}
