import 'package:stock_management_tool/core/constants/constants.dart';
import 'package:stock_management_tool/core/helper/add_new_item_location_history_helper.dart';
import 'package:stock_management_tool/core/helper/add_new_stock_helper.dart';
import 'package:stock_management_tool/core/helper/case_helper.dart';
import 'package:stock_management_tool/core/services/firestore.dart';
import 'package:stock_management_tool/core/services/injection_container.dart';
import 'package:stock_management_tool/features/add_new_stock/data/models/stock_input_field_model.dart';
import 'package:stock_management_tool/features/add_new_stock/domain/repositories/stock_repository.dart';
import 'package:stock_management_tool/objectbox.dart';
import 'package:uuid/uuid.dart';

class StockRepositoryImplementation implements StockRepository {
  final ObjectBox _objectBox = sl.get<ObjectBox>();

  @override
  void listenToCloudDataChange(
      {required List fields, required Function(List) onChange}) {
    _objectBox.getInputFieldStream().listen((snapshot) async {
      String category =
          fields.firstWhere((ele) => ele["field"] == "category")["text_value"];

      if (_objectBox
          .getCategories()
          .any((e) => e.category?.toLowerCase() == category.toLowerCase())) {
        List newFields = _objectBox
            .getInputFields()
            .where((e) =>
                !e.isBackground! &&
                e.category?.toLowerCase() == category.toLowerCase() &&
                e.field != "category")
            .map((e) {
          if (e.field == 'sku') {
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

          Map f = fields.firstWhere((ele) => ele["field"] == e.field,
              orElse: () => <String, dynamic>{});

          return StockInputFieldModel.fromJson({
            ...e.toJson(),
            "is_disabled": f["is_disabled"],
            "text_value": f["text_value"],
          }).toJson();
        }).toList();

        newFields.sort((a, b) => a["order"].compareTo(b["order"]));
        fields.removeWhere((e) => e["field"] != "category");
        fields.addAll(newFields);

        onChange(fields);
      }
    });

    _objectBox.getCategoryStream().listen((snapshot) {
      if (snapshot.isNotEmpty) {
        Map categoryMap =
            fields.firstWhere((ele) => ele["field"] == "category");
        categoryMap["items"] = _objectBox
            .getCategories()
            .map((e) => e.category!)
            .toList()
          ..sort((a, b) => a.compareTo(b));
      }

      onChange(fields);
    });

    _objectBox.getProductStream().listen((snapshot) {
      if (snapshot.isNotEmpty) {
        String category = fields
            .firstWhere((ele) => ele["field"] == "category")["text_value"];

        if (_objectBox.getCategories().any((e) => e.category == category)) {
          Map skuMap = fields.firstWhere((ele) => ele["field"] == "sku");
          skuMap["items"] = _objectBox.getProducts().map((e) => e.sku!).toList()
            ..sort((a, b) => a.compareTo(b));

          if (skuMap["items"].contains(skuMap["text_value"])) {
            fields = getProductDescription(
                category: category, sku: skuMap["text_value"], fields: fields);
          }

          onChange(fields);
        }
      }
    });

    _objectBox.getContainerIdStream().listen((snapshot) {
      if (snapshot.isNotEmpty) {
        String category = fields
            .firstWhere((ele) => ele["field"] == "category")["text_value"];

        if (_objectBox.getCategories().any((e) => e.category == category)) {
          Map containerIdMap =
              fields.firstWhere((ele) => ele["field"] == "container id");
          containerIdMap["items"] = _objectBox
              .getContainerIds()
              .map((e) => e.containerId!)
              .toList()
            ..sort((a, b) => a.compareTo(b));

          if (containerIdMap["items"].contains(containerIdMap["text_value"])) {
            fields.firstWhere((ele) => ele["field"] == "warehouse location id")[
                    "text_value"] =
                getWarehouseLocationId(
                    containerId: containerIdMap["text_value"]);
          }

          onChange(fields);
        }
      }
    });

    _objectBox.getWarehouseLocationIdStream().listen((snapshot) {
      if (snapshot.isNotEmpty) {
        String category = fields
            .firstWhere((ele) => ele["field"] == "category")["text_value"];

        if (_objectBox.getCategories().any((e) => e.category == category)) {
          Map warehouseLocationIdMap = fields
              .firstWhere((ele) => ele["field"] == "warehouse location id");
          warehouseLocationIdMap["items"] = _objectBox
              .getWarehouseLocationIds()
              .map((e) => e.warehouseLocationId!)
              .toList()
            ..sort((a, b) => a.compareTo(b));

          onChange(fields);
        }
      }
    });
  }

  @override
  List<Map<String, dynamic>> getInitialInputFields() {
    List<Map<String, dynamic>> fields = [
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
    return fields;
  }

  @override
  List<Map<String, dynamic>> getCategoryBasedInputFields(
      {required String category}) {
    List fields = _objectBox
        .getInputFields()
        .where((element) =>
            !element.isBackground! &&
            element.category?.toLowerCase() == category.toLowerCase() &&
            element.field != "category")
        .map((e) {
      if (e.field == 'sku') {
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

    fields.sort((a, b) => a["order"].compareTo(b["order"]));

    return fields
        .map((e) => StockInputFieldModel.fromJson(e).toJson())
        .toList();
  }

  @override
  List<Map<String, dynamic>> getProductDescription(
      {required String category, required String sku, required List fields}) {
    Map productDesc = _objectBox
        .getProducts()
        .firstWhere(
            (element) => element.sku?.toUpperCase() == sku.toUpperCase())
        .toJson();

    List f = productDesc["fields"];
    List v = productDesc["values"];

    List affectedFields = fields
        .where((element) =>
            element["in_sku"] &&
            !["category", "sku"].contains(element["field"]))
        .toList();

    for (var element in affectedFields) {
      String val = v[f.indexWhere((e) => e == element["field"])];
      fields.firstWhere((e) => e["field"] == element["field"])["text_value"] =
          CaseHelper.convert(element["value_case"], val);
    }

    return fields as List<Map<String, dynamic>>;
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
      element["text_value"] = CaseHelper.convert(
          element["value_case"], element["text_value"].trim());

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

    await _addNewFieldItems(data: data);
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

  Future<void> _addNewFieldItems({required Map data}) async {
    List fields = _objectBox
        .getInputFields()
        .where((e) =>
            e.category == data["category"] &&
            e.inSku == true &&
            e.items != null &&
            !["category", "sku"].contains(e.field))
        .map((e) => e.toJson())
        .toList();

    List modifiedFields = [];

    for (var field in fields) {
      String value = data[field["field"]];

      if (value != "" && !field["items"].contains(value)) {
        String docRef = field["uid"];
        List items = (field["items"].toSet()..add(data[field["field"]]))
            .toList()
            .cast<String>()
          ..sort((a, b) => a.compareTo(b));

        modifiedFields.add({
          "doc_ref": docRef,
          "items": items,
          ...(field
            ..remove("items")
            ..remove("uid")),
        });
      }
    }

    if (modifiedFields.isNotEmpty) {
      await sl.get<Firestore>().batchWrite(
          path: "category_fields", data: modifiedFields, isToBeUpdated: true);
    }
  }
}
