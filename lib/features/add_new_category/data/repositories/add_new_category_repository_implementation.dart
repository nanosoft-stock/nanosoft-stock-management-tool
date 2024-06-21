import 'package:stock_management_tool/core/data/local_database/models/input_fields_objectbox_model.dart';
import 'package:stock_management_tool/core/helper/case_helper.dart';
import 'package:stock_management_tool/core/helper/string_casting_extension.dart';
import 'package:stock_management_tool/core/services/injection_container.dart';
import 'package:stock_management_tool/features/add_new_category/domain/repositories/add_new_category_repository.dart';
import 'package:stock_management_tool/objectbox.dart';
import 'package:stock_management_tool/objectbox.g.dart';

class AddNewCategoryRepositoryImplementation
    implements AddNewCategoryRepository {
  final ObjectBox _objectBox = sl.get<ObjectBox>();

  @override
  void listenToCloudDataChange(
      {required Map addNewCategoryData,
      required Function(Map) onChange}) async {}

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
  List<String> getInitialRearrangeAbleFields() {
    return [
      "sku",
      "container id",
      "warehouse location id",
    ];
  }

  @override
  Map<String, dynamic> getInitialFieldDetails() {
    List initialFields = [
      "date",
      "category",
      "item id",
      "sku",
      "container id",
      "warehouse location id",
    ];

    Map<String, dynamic> details = {};

    for (var field in initialFields) {
      Query query = _objectBox.inputFieldsBox!
          .query(InputFieldsObjectBoxModel_.field.equals(field))
          .build();
      InputFieldsObjectBoxModel? fieldModel = query.findFirst();
      query.close();

      details[field] = {
        "field": field,
        "datatype": (fieldModel?.datatype ?? "").toTitleCase(),
        "in_sku": (fieldModel?.inSku ?? "") == true ? "True" : "False",
        "is_background":
            (fieldModel?.isBackground ?? "") == true ? "True" : "False",
        "is_lockable":
            (fieldModel?.isLockable ?? "") == true ? "True" : "False",
        "name_case": CaseHelper.convert(
            fieldModel?.nameCase ?? "lower", fieldModel?.nameCase ?? ""),
        "value_case": CaseHelper.convert(
            fieldModel?.valueCase ?? "lower", fieldModel?.valueCase ?? ""),
        "can_edit": false,
        "can_remove": false,
        "can_rearrange":
            ["sku", "container id", "warehouse location id"].contains(field)
                ? true
                : false,
      };
    }

    return details;
  }

  @override
  Map<String, dynamic> getFieldAutoFillData(String field) {
    Query query = _objectBox.inputFieldsBox!
        .query(InputFieldsObjectBoxModel_.field.equals(field.toLowerCase()))
        .build();
    InputFieldsObjectBoxModel? fieldModel = query.findFirst();
    query.close();

    if (fieldModel != null) {
      return fieldModel.toJson();
    }

    return {};
  }

  @override
  Future<void> addNewCategory() async {
    return;
  }
}
