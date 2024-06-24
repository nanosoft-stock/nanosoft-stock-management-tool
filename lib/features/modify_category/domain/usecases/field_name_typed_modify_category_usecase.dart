import 'package:stock_management_tool/core/helper/case_helper.dart';
import 'package:stock_management_tool/core/helper/string_casting_extension.dart';
import 'package:stock_management_tool/core/usecase/usecase.dart';
import 'package:stock_management_tool/features/modify_category/domain/repositories/modify_category_repository.dart';

class FieldNameTypedModifyCategoryUseCase extends UseCase {
  FieldNameTypedModifyCategoryUseCase(this._modifyCategoryRepository);

  final ModifyCategoryRepository _modifyCategoryRepository;

  @override
  Future call({params}) async {
    String title = params["title"];
    String value = params["value"];
    Map<String, dynamic> modifyCategoryData = params["modify_category_data"];

    String displayField = modifyCategoryData["display_field"];

    if (displayField != value) {
      modifyCategoryData["field_details"][value] =
          modifyCategoryData["field_details"][displayField];
      modifyCategoryData["field_details"][value][title] = value;

      modifyCategoryData["field_details"].remove(displayField);

      modifyCategoryData["rearrange_fields"] =
          modifyCategoryData["rearrange_fields"]
              .map((e) => e == displayField ? value : e)
              .toList();

      modifyCategoryData["display_field"] = value;

      Map autoFillData = _modifyCategoryRepository.getFieldAutoFillData(value);

      if (autoFillData.isNotEmpty) {
        modifyCategoryData["field_details"][value].addAll({
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

    return modifyCategoryData;
  }
}
