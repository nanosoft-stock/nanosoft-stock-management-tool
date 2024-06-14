import 'package:stock_management_tool/core/constants/constants.dart';
import 'package:stock_management_tool/core/helper/add_new_item_location_history_helper.dart';
import 'package:stock_management_tool/core/helper/add_new_stock_helper.dart';
import 'package:stock_management_tool/core/helper/string_casting_extension.dart';
import 'package:stock_management_tool/core/services/firestore.dart';
import 'package:stock_management_tool/features/add_new_stock/data/models/stock_input_field_model.dart';
import 'package:stock_management_tool/features/add_new_stock/domain/repositories/stock_repository.dart';
import 'package:stock_management_tool/injection_container.dart';
import 'package:stock_management_tool/objectbox.dart';
import 'package:uuid/uuid.dart';

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

    Map warehouseLocations = {};
    _objectBox.warehouseLocationIdBox!.getAll().forEach((e) {
      warehouseLocations[e.warehouseLocationId] = null;
    });

    Map containers = {};
    _objectBox.containerIdBox!.getAll().forEach((e) {
      containers[e.containerId] = e.toJson()..remove("container_id");
    });

    Map items = {};
    _objectBox.itemIdBox!.getAll().forEach((e) {
      items[e.itemId] = e.toJson()..remove("item_id");
    });

    for (var element in fields) {
      if (element.field == "warehouse location") {
        String container =
            fields.firstWhere((e) => e.field == "container id").textValue;
        if (container != "" &&
            containers[container] != null &&
            containers[container]["warehouse_location_id"] != "") {
          data[element.field] = containers[container]["warehouse_location_id"];
        } else if (container != "") {
          data[element.field] = element.textValue;
          containers[container] = {
            "status": "added",
            "warehouse_location_id": element.textValue,
          };
          if (element.textValue != "") {
            warehouseLocations[element.textValue] = null;
          }
        } else {
          return;
        }
      } else {
        data[element.field] = element.textValue;
      }
    }

    String docRef = await sl.get<Firestore>().createDocument(
          path: "stock_data",
          data: AddNewStockHelper.toJson(data: data),
        );

    items[data["item id"]] = {
      "container_id": data["container id"],
      "doc_ref": docRef,
      "status": "added",
    };

    await _addNewLocation(
      locations: warehouseLocations,
      uid: warehouseLocationIdUid,
      updateField: "warehouse_location_id",
    );

    await _addNewLocation(
      locations: containers,
      uid: containerIdUid,
      updateField: "container_id",
    );

    await _addNewLocation(
      locations: items,
      uid: itemIdUid,
      updateField: "item_id",
    );

    await _addItemLocationHistory(data: data);
  }

  Future<void> _addNewLocation({
    required Map locations,
    required String uid,
    required String updateField,
  }) async {
    Map data = {};

    List tempLocations = locations.keys.toSet().toList();

    for (String e in tempLocations) {
      if (updateField == "warehouse_location_id") {
        data[e] = null;
      } else if (updateField == "container_id") {
        data[e] = {
          "status": locations[e]["status"] ?? "",
          "warehouse_location_id": locations[e]["warehouse_location_id"] ?? "",
        };
      } else if (updateField == "item_id") {
        data[e] = {
          "container_id": locations[e]["container_id"] ?? "",
          "doc_ref": locations[e]["doc_ref"] ?? "",
          "status": locations[e]["status"] ?? "",
        };
      }
    }

    await sl.get<Firestore>().modifyDocument(
          path: "unique_values",
          uid: uid,
          updateMask: [updateField],
          data: !kIsLinux
              ? {
                  updateField: data,
                }
              : {
                  updateField: {
                    "mapValue": {
                      "fields": {
                        data.map(
                          (k, v) => MapEntry(
                            k,
                            v != null
                                ? {
                                    "mapValue": {
                                      "fields": v.map(
                                        (k1, v1) => MapEntry(
                                          k1,
                                          {
                                            "stringValue": v1,
                                          },
                                        ),
                                      ),
                                    },
                                  }
                                : null,
                          ),
                        )
                      }
                    }
                  }
                },
        );
  }

  Future<void> _addItemLocationHistory({required Map data}) async {
    Map map = {
      "group_id": const Uuid().v1(),
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
