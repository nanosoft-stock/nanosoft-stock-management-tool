import 'package:stock_management_tool/core/usecase/usecase.dart';
import 'package:stock_management_tool/features/add_new_category/domain/repositories/add_new_category_repository.dart';

class AddNewCategoryPressedUseCase extends UseCase {
  AddNewCategoryPressedUseCase(this._addNewCategoryRepository);

  final AddNewCategoryRepository _addNewCategoryRepository;

  @override
  Future call({params}) async {
    Map<String, dynamic> addNewCategoryData = params["add_new_category_data"];

    await _addNewCategoryRepository.addNewCategory(addNewCategoryData);

    addNewCategoryData["category_text"] = "";
    addNewCategoryData["categories"] =
        _addNewCategoryRepository.getAllCategories();
    addNewCategoryData["display_field"] = "date";
    addNewCategoryData["options"] = _addNewCategoryRepository.getOptions();
    addNewCategoryData["field_data_fields"] =
        _addNewCategoryRepository.getFieldDataFields();
    addNewCategoryData["tool_tips"] = _addNewCategoryRepository.getToolTips();
    addNewCategoryData["rearrange_fields"] =
        _addNewCategoryRepository.getInitialRearrangeAbleFields();
    addNewCategoryData["field_details"] =
        _addNewCategoryRepository.getInitialFieldDetails();

    return addNewCategoryData;
  }
}
