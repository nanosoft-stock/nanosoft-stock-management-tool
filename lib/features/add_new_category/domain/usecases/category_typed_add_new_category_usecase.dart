import 'package:stock_management_tool/core/usecase/usecase.dart';

class CategoryTypedAddNewCategoryUseCase extends UseCase {
  CategoryTypedAddNewCategoryUseCase();

  @override
  Future call({params}) async {
    String category = params["category"];
    Map<String, dynamic> addNewCategoryData = params["add_new_category_data"];

    addNewCategoryData["category_text"] = category;

    return addNewCategoryData;
  }
}
