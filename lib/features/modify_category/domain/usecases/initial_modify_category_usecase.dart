import 'package:stock_management_tool/core/usecase/usecase.dart';
import 'package:stock_management_tool/features/modify_category/domain/repositories/modify_category_repository.dart';

class InitialModifyCategoryUseCase extends UseCase {
  InitialModifyCategoryUseCase(this._modifyCategoryRepository);

  final ModifyCategoryRepository _modifyCategoryRepository;

  @override
  Future call({params}) async {
    Map<String, dynamic> addNewCategoryData = {};

    addNewCategoryData["category_text"] = "";
    addNewCategoryData["categories"] =
        _modifyCategoryRepository.getAllCategories();
    addNewCategoryData["display_field"] = null;
    addNewCategoryData["options"] = _modifyCategoryRepository.getOptions();
    addNewCategoryData["field_data_fields"] =
        _modifyCategoryRepository.getFieldDataFields();
    addNewCategoryData["tool_tips"] = _modifyCategoryRepository.getToolTips();

    return addNewCategoryData;
  }
}
