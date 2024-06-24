import 'package:stock_management_tool/core/helper/case_helper.dart';
import 'package:stock_management_tool/core/helper/string_casting_extension.dart';
import 'package:stock_management_tool/core/usecase/usecase.dart';
import 'package:stock_management_tool/features/add_new_category/domain/repositories/add_new_category_repository.dart';

class FieldNameTypedAddNewCategoryUseCase extends UseCase {
  FieldNameTypedAddNewCategoryUseCase(this._addNewCategoryRepository);

  final AddNewCategoryRepository _addNewCategoryRepository;

  @override
  Future call({params}) async {
    String title = params["title"];
    String value = params["value"];
    Map<String, dynamic> addNewCategoryData = params["add_new_category_data"];

    String displayField = addNewCategoryData["display_field"];

    if (displayField != value) {
      addNewCategoryData["field_details"][value] =
          addNewCategoryData["field_details"][displayField];
      addNewCategoryData["field_details"][value][title] = value;

      addNewCategoryData["field_details"].remove(displayField);

      addNewCategoryData["rearrange_fields"] =
          addNewCategoryData["rearrange_fields"]
              .map((e) => e == displayField ? value : e)
              .toList();

      addNewCategoryData["display_field"] = value;

      Map autoFillData = _addNewCategoryRepository.getFieldAutoFillData(value);

      if (autoFillData.isNotEmpty) {
        addNewCategoryData["field_details"][value].addAll({
          "datatype": (autoFillData["datatype"] ?? "").toString().toTitleCase(),
          "in_sku": (autoFillData["in_sku"] ?? "") == true ? "True" : "False",
          "is_background":
              (autoFillData["is_background"] ?? "") == true ? "True" : "False",
          "is_lockable":
              (autoFillData["is_lockable"] ?? "") == true ? "True" : "False",
          "name_case": CaseHelper.convert(autoFillData["name_case"] ?? "lower",
              autoFillData["name_case"] ?? ""),
          "value_case": CaseHelper.convert(
              autoFillData["value_case"] ?? "lower",
              autoFillData["value_case"] ?? ""),
        });
      }
    }

    return addNewCategoryData;
  }
}
