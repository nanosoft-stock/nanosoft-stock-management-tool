import 'package:stock_management_tool/core/usecase/usecase.dart';
import 'package:stock_management_tool/features/modify_category/domain/repositories/modify_category_repository.dart';

class ModifyCategoryPressedUseCase extends UseCase {
  ModifyCategoryPressedUseCase(this._modifyCategoryRepository);

  final ModifyCategoryRepository _modifyCategoryRepository;

  @override
  Future call({params}) async {
    Map<String, dynamic> modifyCategoryData = params["modify_category_data"];

    await _modifyCategoryRepository.modifyCategory(modifyCategoryData);

    modifyCategoryData["category_text"] = "";
    modifyCategoryData["categories"] =
        _modifyCategoryRepository.getAllCategories();
    modifyCategoryData["display_field"] = null;
    modifyCategoryData["options"] = _modifyCategoryRepository.getOptions();
    modifyCategoryData["field_data_fields"] =
        _modifyCategoryRepository.getFieldDataFields();
    modifyCategoryData["tool_tips"] = _modifyCategoryRepository.getToolTips();
    modifyCategoryData
      ..remove("rearrange_fields")
      ..remove("field_details");

    return modifyCategoryData;
  }
}
