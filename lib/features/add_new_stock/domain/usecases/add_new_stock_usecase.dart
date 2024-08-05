import 'package:stock_management_tool/core/local_database/local_database.dart';
import 'package:stock_management_tool/core/resources/application_error.dart';
import 'package:stock_management_tool/core/usecase/usecase.dart';
import 'package:stock_management_tool/features/add_new_stock/domain/repositories/stock_repository.dart';

class AddNewStockUseCase extends UseCase {
  AddNewStockUseCase(this._stockRepository, this._localDB);

  final StockRepository _stockRepository;
  final LocalDatabase _localDB;

  @override
  Future call({params}) async {
    List fields = params["fields"];

    if (_inputValidation(fields)) {
      await _stockRepository.addNewStock(fields: fields);

      if (fields[0]["field"] == "category" &&
          fields[0]["is_disabled"] == true) {
        for (int i = 0; i < fields.length; i++) {
          if (!fields[i]["is_disabled"]) {
            fields[i]["text_value"] = "";
          }
        }
      } else {
        fields.removeWhere((e) => e["field"] != "category");
        fields[0]["text_value"] = "";
      }
    }

    return fields;
  }

  bool _inputValidation(List fields) {
    for (var field in fields) {
      if (field["field"] == "category") {
        _categoryValidation(field);
      } else if (field["field"] == "item id") {
        _itemIdValidation(field);
      } else if (field["field"] == "container id") {
        _containerIdValidation(
            field,
            fields.firstWhere(
                (e) => e["field"] == "warehouse location id")["text_value"]);
      } else if (field["field"] == "warehouse location id") {
        _warehouseLocationIdValidation(field);
      }
    }

    return true;
  }

  void _categoryValidation(Map field) {
    if (field["text_value"].trim() == "") {
      throw const ValidationError(message: "Category can't be empty");
    }

    try {
      _localDB.categories.firstWhere((element) =>
          element.category!.toLowerCase() ==
          field["text_value"].trim().toLowerCase());
    } catch (error) {
      throw const ValidationError(message: "Invalid Category");
    }
  }

  void _itemIdValidation(Map field) {
    var item;

    try {
      item = _localDB.items.firstWhere(
          (element) => element.itemId == field["text_value"].trim());
    } catch (error) {
      throw const ValidationError(message: "Item Id hasn't been Assigned");
    }

    if (item.status == "added") {
      throw const ValidationError(message: "Item has already been added");
    }
  }

  void _containerIdValidation(Map field, String warehouseLocationId) {
    var container;

    try {
      container = _localDB.containers.firstWhere((element) =>
          element.containerId!.toLowerCase() ==
          field["text_value"].toLowerCase().trim());
    } catch (error) {
      throw const ValidationError(message: "Container Id hasn't been Assigned");
    }

    if (container.warehouseLocationId!.toLowerCase() !=
        warehouseLocationId.trim().toLowerCase()) {
      throw const ValidationError(
          message: "Container Id isn't present in this Warehouse Location");
    }
  }

  void _warehouseLocationIdValidation(Map field) {
    try {
      _localDB.warehouseLocations.firstWhere((element) =>
          element.warehouseLocationId!.toLowerCase() ==
          field["text_value"].toLowerCase().trim());
    } catch (error) {
      throw const ValidationError(
          message: "Warehouse Location Id hasn't been Assigned");
    }
  }
}
