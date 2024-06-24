import 'package:stock_management_tool/core/usecase/usecase.dart';

class DetailsTypedAddNewCategoryUseCase extends UseCase {
  DetailsTypedAddNewCategoryUseCase();

  @override
  Future call({params}) async {
    String title = params["title"];
    String value = params["value"];
    Map<String, dynamic> addNewCategoryData = params["add_new_category_data"];

    String displayField = addNewCategoryData["display_field"];

    addNewCategoryData["field_details"][displayField][title] = value;

    return addNewCategoryData;
  }
}
