import 'package:stock_management_tool/core/usecase/usecase.dart';

class ViewFieldDetailsAddNewCategoryUseCase extends UseCase {
  ViewFieldDetailsAddNewCategoryUseCase();

  @override
  Future call({params}) async {
    String field = params["field"];
    Map<String, dynamic> addNewCategoryData = params["add_new_category_data"];

    addNewCategoryData["display_field"] = field;

    return addNewCategoryData;
  }
}
