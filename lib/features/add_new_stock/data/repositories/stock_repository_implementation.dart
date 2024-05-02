import 'package:stock_management_tool/constants/constants.dart';
import 'package:stock_management_tool/features/add_new_stock/data/models/stock_input_field_model.dart';
import 'package:stock_management_tool/features/add_new_stock/domain/repositories/stock_repository.dart';
import 'package:stock_management_tool/helper/add_new_item_location_history_helper.dart';
import 'package:stock_management_tool/helper/add_new_stock_helper.dart';
import 'package:stock_management_tool/helper/string_casting_extension.dart';
import 'package:stock_management_tool/injection_container.dart';
import 'package:stock_management_tool/objectbox.dart';
import 'package:stock_management_tool/services/firestore.dart';

class StockRepositoryImplementation implements StockRepository {
  final ObjectBox _objectBox = sl.get<ObjectBox>();

  @override
  Future<List<StockInputFieldModel>> getInitialInputFields() async {
    return [
      {
        "uid": "",
        "field": "category",
        "datatype": "string",
        "lockable": true,
        "isWithSKU": true,
        "isTitleCase": true,
        "isBg": false,
        "order": 2,
        "items": _objectBox
            .getCategories()
            .map((e) => e.category!.toTitleCase())
            .toList()
      },
    ].map((e) => StockInputFieldModel.fromJson(e)).toList();
  }

  @override
  Future<List<StockInputFieldModel>> getCategoryBasedInputFields(
      {required String category}) async {
    List fields = _objectBox
        .getInputFields()
        .where((element) =>
            !element.isBg! &&
            element.category == category.toLowerCase() &&
            element.field != "category")
        .map((e) {
      if (e.field == 'sku') {
        e.items = _objectBox
            .getProducts()
            .where((element) => element.category == category.toLowerCase())
            .map((e) => e.sku!)
            .toList();
      }
      return e.toJson();
    }).toList();

    return fields.map((e) => StockInputFieldModel.fromJson(e)).toList();
  }

  @override
  Future<Map> getProductDescription(
      {required String category, required String sku}) async {
    return _objectBox
        .getProducts()
        .where((element) =>
            element.category == category.toLowerCase() && element.sku == sku)
        .map((e) => e.toJson())
        .toList()[0];
  }

  @override
  Future addNewStock({required List<dynamic> fields}) async {
    Map data = {};

    for (var element in fields) {
      data[element.field] = element.textValue;
    }

    await sl.get<Firestore>().createDocument(
          path: "stock_data",
          data: AddNewStockHelper.toJson(data: data),
        );

    List allLocations = await _fetchAllLocations();

    Map warehouseLocations = allLocations
        .firstWhere((element) => element.keys.contains("warehouse_locations"));
    Map containers = allLocations
        .firstWhere((element) => element.keys.contains("containers"));
    Map items =
        allLocations.firstWhere((element) => element.keys.contains("items"));

    await _addNewLocations(
      locations: warehouseLocations["warehouse_locations"],
      newValue: data["warehouse location"],
      uid: warehouseLocations["uid"],
      updateField: "warehouse_locations",
    );

    await _addNewLocations(
      locations: containers["containers"],
      newValue: data["container id"],
      uid: containers["uid"],
      updateField: "containers",
    );

    await _addNewLocations(
      locations: items["items"],
      newValue: data["item id"],
      uid: items["uid"],
      updateField: "items",
    );

    await _addItemLocationHistory(data: data);
  }

  Future<List> _fetchAllLocations() async {
    List allLocations = await sl
        .get<Firestore>()
        .getDocuments(path: "all_locations", includeUid: true);

    if (kIsLinux) {
      allLocations = allLocations.map((element) {
        Map map = {};

        for (var key in element.keys) {
          if (key == "uid") {
            map["uid"] = element["uid"]["stringValue"];
          } else {
            map[key] = element[key]["arrayValue"]["values"]
                .map((ele) => ele["stringValue"])
                .toList();
          }
        }

        return map;
      }).toList();
    }

    return allLocations;
  }

  Future<void> _addNewLocations({
    required List locations,
    required String? newValue,
    required String uid,
    required String updateField,
  }) async {
    if (newValue != null &&
        newValue.toString().trim() != "" &&
        !locations.contains(newValue.toString().trim())) {
      locations.add(newValue.toString().trim().toUpperCase());

      locations = locations.toSet().toList();

      locations.sort((a, b) => a.toString().compareTo(b.toString()));

      await sl.get<Firestore>().modifyDocument(
            path: "all_locations",
            uid: uid,
            updateMask: [updateField],
            data: !kIsLinux
                ? {
                    updateField: locations,
                  }
                : {
                    updateField: {
                      "arrayValue": {
                        "values":
                            locations.map((e) => {"stringValue": e}).toList(),
                      }
                    }
                  },
          );
    }
  }

  Future<void> _addItemLocationHistory({required Map data}) async {
    Map map = {
      "items": [data["item id"]],
      "container_id": data["container id"],
      "warehouse_location_id": data["warehouse location"],
      "move_type": "initial",
      "state": "completed",
    };

    await sl.get<Firestore>().createDocument(
          path: "stock_location_history",
          data: AddNewItemLocationHistoryHelper.toJson(data: map),
        );
  }
}
