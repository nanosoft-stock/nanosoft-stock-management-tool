import 'package:stock_management_tool/core/constants/constants.dart';
import 'package:stock_management_tool/core/helper/add_new_item_location_history_helper.dart';
import 'package:stock_management_tool/core/helper/add_new_stock_helper.dart';
import 'package:stock_management_tool/core/helper/case_helper.dart';
import 'package:stock_management_tool/core/services/firestore.dart';
import 'package:stock_management_tool/features/add_new_stock/data/models/stock_input_field_model.dart';
import 'package:stock_management_tool/features/add_new_stock/domain/repositories/stock_repository.dart';
import 'package:stock_management_tool/injection_container.dart';
import 'package:stock_management_tool/objectbox.dart';
import 'package:uuid/uuid.dart';

class StockRepositoryImplementation implements StockRepository {
  final ObjectBox _objectBox = sl.get<ObjectBox>();

  @override
  List<Map<String, dynamic>> getInitialInputFields() {
    return [
      {
        "field": "category",
        "datatype": "string",
        "in_sku": true,
        "is_background": false,
        "is_lockable": true,
        "items": _objectBox.getCategories().map((e) => e.category!).toList()
          ..sort((a, b) => a.compareTo(b)),
        "name_case": "title",
        "value_case": "none",
        "order": 2,
      },
    ].map((e) => StockInputFieldModel.fromJson(e).toJson()).toList();
  }

  @override
  List<Map<String, dynamic>> getCategoryBasedInputFields(
      {required String category}) {
    List fields = _objectBox
        .getInputFields()
        .where((element) =>
            !element.isBackground! &&
            element.category?.toLowerCase() == category.toLowerCase())
        .map((e) {
      if (e.field == "category") {
        return {
          ...e.toJson(),
          "items": _objectBox.getCategories().map((e) => e.category!).toList()
            ..sort((a, b) => a.compareTo(b)),
          "text_value": category,
        };
      } else if (e.field == 'sku') {
        e.items = _objectBox
            .getProducts()
            .where((element) =>
                element.category?.toLowerCase() == category.toLowerCase())
            .map((e) => e.sku!)
            .toList()
          ..sort((a, b) => a.compareTo(b));
      } else if (e.field == "container id") {
        e.items = _objectBox
            .getContainerIds()
            .map((e) => e.containerId!)
            .toList()
          ..sort((a, b) => a.compareTo(b));
      } else if (e.field == "warehouse location id") {
        e.items = _objectBox
            .getWarehouseLocationIds()
            .map((e) => e.warehouseLocationId!)
            .toList()
          ..sort((a, b) => a.compareTo(b));
      }
      return e.toJson();
    }).toList();

    return fields
        .map((e) => StockInputFieldModel.fromJson(e).toJson())
        .toList();
  }

  @override
  Map<String, dynamic> getProductDescription(
      {required String category, required String sku}) {
    return _objectBox
        .getProducts()
        .firstWhere(
            (element) => element.sku?.toUpperCase() == sku.toUpperCase())
        .toJson();
  }

  @override
  String getWarehouseLocationId({required String containerId}) {
    return _objectBox
            .getContainerIds()
            .firstWhere(
                (element) => element.containerId == containerId.toUpperCase())
            .warehouseLocationId ??
        "";
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
      element["text_value"] =
          CaseHelper.convert(element["value_case"], element["text_value"]);

      if (element["field"] == "warehouse location id") {
        String container = fields
            .firstWhere((e) => e["field"] == "container id")["text_value"];
        if (container != "" &&
            containers[container] != null &&
            containers[container]["warehouse_location_id"] != "") {
          data[element["field"]] =
              containers[container]["warehouse_location_id"];
        } else if (container != "") {
          data[element["field"]] = element["text_value"];
          containers[container] = {
            "status": "added",
            "warehouse_location_id": element["text_value"],
          };
          if (element["text_value"] != "") {
            warehouseLocations[element["text_value"]] = null;
          }
        } else {
          return;
        }
      } else {
        data[element["field"]] = element["text_value"];
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
      "warehouse_location_id": data["warehouse location id"],
      "move_type": "initial",
      "state": "completed",
    };

    await sl.get<Firestore>().createDocument(
          path: "stock_location_history",
          data: AddNewItemLocationHistoryHelper.toJson(data: map),
        );
  }
}
