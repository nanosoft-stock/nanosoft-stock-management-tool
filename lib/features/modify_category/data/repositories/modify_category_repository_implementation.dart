import 'package:stock_management_tool/core/helper/add_new_field_helper.dart';
import 'package:stock_management_tool/core/helper/case_helper.dart';
import 'package:stock_management_tool/core/helper/string_casting_extension.dart';
import 'package:stock_management_tool/core/local_database/local_database.dart';
import 'package:stock_management_tool/core/services/firestore.dart';
import 'package:stock_management_tool/core/services/injection_container.dart';
import 'package:stock_management_tool/features/modify_category/domain/repositories/modify_category_repository.dart';

class ModifyCategoryRepositoryImplementation
    implements ModifyCategoryRepository {
  ModifyCategoryRepositoryImplementation(this._localDB);

  final LocalDatabase _localDB;

  @override
  void listenToCloudDataChange(
      {required Map modifyCategoryData,
      required Function(Map) onChange}) async {
    _localDB.categoryStream().listen((snapshot) {
      modifyCategoryData["categories"] =
          _localDB.categories.map((e) => e.category!).toList();
      onChange(modifyCategoryData);
    });
  }

  @override
  List<String> getAllCategories() {
    return _localDB.categories.map((e) => e.category!).toList();
  }

  @override
  Map<String, dynamic> getOptions() {
    return {
      "datatype": ["Timestamp", "String"],
      "in_sku": ["False", "True"],
      "is_background": ["False", "True"],
      "is_lockable": ["False", "True"],
      "name_case": ["lower", "Title", "UPPER"],
      "value_case": ["none", "lower", "Title", "UPPER"],
    };
  }

  @override
  Map<String, dynamic> getFieldDataFields() {
    return {
      "field": "Field",
      "datatype": "Data Type",
      "in_sku": "In SKU",
      "is_background": "Is Background",
      "is_lockable": "Is Lockable",
      "name_case": "Name Case",
      "value_case": "Value Case",
    };
  }

  @override
  Map<String, dynamic> getToolTips() {
    return {
      "field": "Name of the Field",
      "datatype":
          "Data Type the field should store\n\nTimestamp: Date and Time\nString: Alphabets and Numbers",
      "in_sku":
          "Should the field be include in SKU for the category\n\nTrue: Field will be included\nFalse: Field is omitted",
      "is_background":
          "Should the field be auto-filled by the Application\n\nTrue: Auto-filled\nFalse: User-filled",
      "is_lockable":
          "Can the field contain duplicate values\n\nTrue: Field can contain duplicate values\nFalse: Field cannot contain duplicate values",
      "name_case": "Case in which the Field Name is displayed",
      "value_case":
          "Case in which the Field Value is displayed\n\nnone: Value is displayed how it is entered",
    };
  }

  @override
  List<String> getRearrangeAbleFields(String category) {
    return (_localDB.categoryFields.toList()
          ..sort((a, b) => a.displayOrder!.compareTo(b.displayOrder!)))
        .where((e) => e.category == category)
        .where((e) => !["date", "category", "item id"].contains(e.field))
        .map((e) => e.field!)
        .toList();
  }

  @override
  Map<String, dynamic> getFieldDetails(String category) {
    List fields =
        _localDB.categoryFields.where((e) => e.category == category).toList();

    List irReplaceableFields = [
      "date",
      "category",
      "item id",
      "sku",
      "container id",
      "warehouse location id",
      "user",
    ];

    Map<String, dynamic> details = {};

    for (var field in fields) {
      details[field.field] = {
        "field": field.field,
        "datatype": (field?.datatype ?? "").toString().toTitleCase(),
        "in_sku": (field?.inSku ?? "") == true ? "True" : "False",
        "is_background": (field?.isBackground ?? "") == true ? "True" : "False",
        "is_lockable": (field?.isLockable ?? "") == true ? "True" : "False",
        "name_case": CaseHelper.convert(
            field?.nameCase ?? "lower", field?.nameCase ?? ""),
        "value_case": CaseHelper.convert(
            field?.valueCase ?? "lower", field?.valueCase ?? ""),
        "can_edit": !irReplaceableFields.contains(field.field) ? true : false,
        "can_remove": !irReplaceableFields.contains(field.field) ? true : false,
      };
    }

    return details;
  }

  @override
  Map<String, dynamic> getFieldAutoFillData(String field) {
    List fields = _localDB.categoryFields
        .where((element) => element.field!.toLowerCase() == field.toLowerCase())
        .toList();

    if (fields.isNotEmpty) {
      return fields.first.toMap();
    }

    return {};
  }

  @override
  Future<void> modifyCategory(Map<String, dynamic> modifyCategoryData) async {
    List allFields = [
      "date",
      "category",
      "item id",
      ...modifyCategoryData["rearrange_fields"],
    ];

    List<Map<String, dynamic>> storedFields = _localDB.categoryFields
        .where((e) =>
            e.category!.toLowerCase() ==
            modifyCategoryData["category_text"].toLowerCase())
        .map((e) => e.toMap())
        .toList();

    List<Map<String, dynamic>> allFieldDetails = [];

    for (int i = 0; i < allFields.length; i++) {
      Map field = modifyCategoryData["field_details"][allFields[i]];

      allFieldDetails.add(AddNewFieldHelper.toJson(data: {
        "field": field["field"],
        "category": modifyCategoryData["category_text"],
        "datatype": field["datatype"].toLowerCase(),
        "in_sku": field["in_sku"].toLowerCase() == "true",
        "is_background": field["is_background"].toLowerCase() == "true",
        "is_lockable": field["is_lockable"].toLowerCase() == "true",
        "items": storedFields.firstWhere((e) => e["field"] == field["field"],
            orElse: () => {})["items"],
        "name_case": field["name_case"].toLowerCase(),
        "value_case": field["value_case"].toLowerCase(),
        "order": i + 1,
      }));
    }

    List docRefsToRemove =
        storedFields.map((e) => {"doc_ref": e["uid"]}).toList();

    await sl.get<Firestore>().batchWrite(
        path: "category_fields", data: docRefsToRemove, op: "delete");

    await sl
        .get<Firestore>()
        .batchWrite(path: "category_fields", data: allFieldDetails, op: "add");
  }
}
