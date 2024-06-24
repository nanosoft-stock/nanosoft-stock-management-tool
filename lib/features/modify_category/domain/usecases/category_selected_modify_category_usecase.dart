import 'package:stock_management_tool/core/usecase/usecase.dart';
import 'package:stock_management_tool/features/modify_category/domain/repositories/modify_category_repository.dart';

class CategorySelectedModifyCategoryUseCase extends UseCase {
  CategorySelectedModifyCategoryUseCase(this._modifyCategoryRepository);

  final ModifyCategoryRepository _modifyCategoryRepository;

  @override
  Future call({params}) async {
    String category = params["category"];
    Map<String, dynamic> modifyCategoryData = params["modify_category_data"];

    modifyCategoryData["category_text"] = category;

    if (modifyCategoryData["categories"].contains(category)) {
      modifyCategoryData["rearrange_fields"] =
          _modifyCategoryRepository.getRearrangeAbleFields(category);
      modifyCategoryData["field_details"] =
          _modifyCategoryRepository.getFieldDetails(category);

      modifyCategoryData["display_field"] = "date";
    } else {
      modifyCategoryData["display_field"] = null;
      modifyCategoryData
        ..remove("rearrange_fields")
        ..remove("field_details");
    }

    return modifyCategoryData;
  }
}
