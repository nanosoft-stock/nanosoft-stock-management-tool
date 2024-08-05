import 'package:stock_management_tool/core/helper/add_new_stock_helper.dart';
import 'package:stock_management_tool/core/local_database/local_database.dart';
import 'package:stock_management_tool/core/resources/data_state.dart';
import 'package:stock_management_tool/core/services/injection_container.dart';
import 'package:stock_management_tool/core/services/network_services.dart';
import 'package:stock_management_tool/features/add_new_stock/data/models/stock_input_field_model.dart';
import 'package:stock_management_tool/features/add_new_stock/domain/repositories/stock_repository.dart';

class StockRepositoryImplementation implements StockRepository {
  StockRepositoryImplementation(this._localDB, this._networkServices);

  final LocalDatabase _localDB;
  final NetworkServices _networkServices;

  @override
  void listenToCloudDataChange(
      {required List fields, required Function() onChange}) {
    // _objectBox.getInputFieldStream().listen((snapshot) async {
    //   String category =
    //       fields.firstWhere((ele) => ele["field"] == "category")["text_value"];

    //   if (_objectBox
    //       .getCategories()
    //       .any((e) => e.category?.toLowerCase() == category.toLowerCase())) {
    //     List newFields = _objectBox
    //         .getInputFields()
    //         .where((e) =>
    //             !e.isBackground! &&
    //             e.category?.toLowerCase() == category.toLowerCase() &&
    //             e.field != "category")
    //         .map((e) {
    //       if (e.field == 'sku') {
    //         e.items = _objectBox
    //             .getProducts()
    //             .where((element) =>
    //                 element.category?.toLowerCase() == category.toLowerCase())
    //             .map((e) => e.sku!)
    //             .toList()
    //           ..sort((a, b) => a.compareTo(b));
    //       } else if (e.field == "container id") {
    //         e.items = _objectBox
    //             .getContainerIds()
    //             .map((e) => e.containerId!)
    //             .toList()
    //           ..sort((a, b) => a.compareTo(b));
    //       } else if (e.field == "warehouse location id") {
    //         e.items = _objectBox
    //             .getWarehouseLocationIds()
    //             .map((e) => e.warehouseLocationId!)
    //             .toList()
    //           ..sort((a, b) => a.compareTo(b));
    //       }

    //       Map f = fields.firstWhere((ele) => ele["field"] == e.field,
    //           orElse: () => <String, dynamic>{});

    //   return StockInputFieldModel.fromJson({
    //     ...e.toJson(),
    //     "is_disabled": f["is_disabled"],
    //     "text_value": f["text_value"],
    //   }).toJson();
    // }).toList();

    //     newFields.sort((a, b) => a["order"].compareTo(b["order"]));
    //     fields.removeWhere((e) => e["field"] != "category");
    //     fields.addAll(newFields);

    //     onChange(fields);
    //   }
    // });

    _localDB.categoryStream().listen((snapshot) {
      Map categoryMap = fields.firstWhere((ele) => ele["field"] == "category");

      categoryMap["items"] = _localDB.categories
          .map((e) => e.category!)
          .toList()
        ..sort((a, b) => a.compareTo(b));

      onChange();
    });

    // _objectBox.getProductStream().listen((snapshot) {
    //   if (snapshot.isNotEmpty) {
    //     String category = fields
    //         .firstWhere((ele) => ele["field"] == "category")["text_value"];

    //     if (_objectBox.getCategories().any((e) => e.category == category)) {
    //       Map skuMap = fields.firstWhere((ele) => ele["field"] == "sku");
    //       skuMap["items"] = _objectBox.getProducts().map((e) => e.sku!).toList()
    //         ..sort((a, b) => a.compareTo(b));

    //       if (skuMap["items"].contains(skuMap["text_value"])) {
    //         fields = getProductDescription(
    //             category: category, sku: skuMap["text_value"], fields: fields);
    //       }

    //       onChange(fields);
    //     }
    //   }
    // });

    _localDB.containerStream().listen((snapshot) {
      String category =
          fields.firstWhere((ele) => ele["field"] == "category")["text_value"];

      if (_localDB.categories
          .any((e) => e.category?.toLowerCase() == category.toLowerCase())) {
        Map containerIdMap =
            fields.firstWhere((ele) => ele["field"] == "container id");
        containerIdMap["items"] = _localDB.containers
            .map((e) => e.containerId!)
            .toList()
          ..sort((a, b) => a.compareTo(b));

        if (containerIdMap["items"].contains(containerIdMap["text_value"])) {
          fields.firstWhere((ele) => ele["field"] == "warehouse location id")[
                  "text_value"] =
              getWarehouseLocationId(containerId: containerIdMap["text_value"]);
        }

        onChange();
      }
    });

    _localDB.warehouseLocationStream().listen((snapshot) {
      String category =
          fields.firstWhere((ele) => ele["field"] == "category")["text_value"];

      if (_localDB.categories.any((e) => e.category! == category)) {
        Map warehouseLocationIdMap =
            fields.firstWhere((ele) => ele["field"] == "warehouse location id");

        warehouseLocationIdMap["items"] = _localDB.warehouseLocations
            .map((e) => e.warehouseLocationId!)
            .toList()
          ..sort((a, b) => a.compareTo(b));

        onChange();
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
        "items": _localDB.categories.map((e) => e.category!).toList()
          ..sort((a, b) => a.compareTo(b)),
        "name_case": "title",
        "value_case": "none",
        "order": 2,
      },
    ].map((e) => StockInputFieldModel.fromMap(e).toMap()).toList();
    return fields;
  }

  @override
  Future<List<Map<String, dynamic>>> getCategoryBasedInputFields(
      {required String category}) async {
    List categoryBasedFields = _localDB.categoryFields
        .where((element) =>
            !element.isBackground! &&
            element.category?.toLowerCase() == category.toLowerCase() &&
            element.field != "category")
        .toList();

    List fields = [];

    for (var ele in categoryBasedFields) {
      if (ele.field == 'sku') {
      } else if (ele.field == 'container id') {
        ele.items = _localDB.containers.map((e) => e.containerId!).toList();
      } else if (ele.field == 'warehouse location id') {
        ele.items = _localDB.warehouseLocations
            .map((e) => e.warehouseLocationId!)
            .toList();
      } else if (!["item id", "serial number", "supplier info", "comments"]
          .contains(ele.field)) {
        ele.items = await _getFieldItems(
            category, ele.field!.toLowerCase().replaceAll(" ", "_"));
      }

      fields.add(ele.toMap());
    }

    fields.sort((a, b) => a["display_order"].compareTo(b["display_order"]));

    return fields.map((e) => StockInputFieldModel.fromMap(e).toMap()).toList();
  }

  Future<List<String>> _getFieldItems(category, field) async {
    DataState items = await _networkServices.query("stocks", {
      "data": {
        "distinct": true,
        "columns": [
          "${category.toLowerCase().replaceAll(" ", "_")}_specifications.$field",
        ],
        "join": [
          {
            "type": "INNER",
            "field": "item_id",
            "table":
                "${category.toLowerCase().replaceAll(" ", "_")}_specifications",
          },
        ],
        "where": [
          {
            "field": "category",
            "op": "=",
            "value": category,
          },
        ],
        "order_by": [
          {
            "field":
                "${category.toLowerCase().replaceAll(" ", "_")}_specifications.$field",
            "direction": "ASC",
          },
        ]
      },
    });

    if (items is DataFailed) {
      throw items.error!;
    } else {
      return items.data.map((e) => e[field]).toList().cast<String>();
    }
  }

  @override
  List<Map<String, dynamic>> getProductDescription(
      {required String category, required String sku, required List fields}) {
    // Map productDesc = _objectBox
    //     .getProducts()
    //     .firstWhere(
    //         (element) => element.sku?.toUpperCase() == sku.toUpperCase())
    //     .toJson();

    // List f = productDesc["fields"];
    // List v = productDesc["values"];

    // List affectedFields = fields
    //     .where((element) =>
    //         element["in_sku"] &&
    //         !["category", "sku"].contains(element["field"]))
    //     .toList();

    // for (var element in affectedFields) {
    //   String val = v[f.indexWhere((e) => e == element["field"])];
    //   fields.firstWhere((e) => e["field"] == element["field"])["text_value"] =
    //       CaseHelper.convert(element["value_case"], val);
    // }

    // return fields as List<Map<String, dynamic>>;
    return [];
  }

  @override
  String getWarehouseLocationId({required String containerId}) {
    return _localDB.containers
            .firstWhere((container) =>
                container.containerId!.toLowerCase() ==
                containerId.toLowerCase())
            .warehouseLocationId ??
        "";
  }

  @override
  Future addNewStock({required List<dynamic> fields}) async {
    Map data = {};

    for (var field in fields) {
      data[field["field"]] = field["text_value"].trim();
    }

    print(AddNewStockHelper.toMap(
      data: data,
    ));

    DataState dataState = await sl.get<NetworkServices>().post(
      "stocks",
      {
        "data": AddNewStockHelper.toMap(
          data: data,
        ),
      },
    );

    if (dataState is DataFailed) {
      throw dataState.error!;
    }
  }
}
