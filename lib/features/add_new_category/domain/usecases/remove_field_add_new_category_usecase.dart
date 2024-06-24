import 'package:stock_management_tool/core/usecase/usecase.dart';

class RemoveFieldAddNewCategoryUseCase extends UseCase {
  RemoveFieldAddNewCategoryUseCase();

  @override
  Future call({params}) async {
    Map<String, dynamic> addNewCategoryData = params["add_new_category_data"];

    String displayField = addNewCategoryData["display_field"];

    addNewCategoryData["field_details"].remove(displayField);
    addNewCategoryData["rearrange_fields"].remove(displayField);

    if ((addNewCategoryData["rearrange_fields"] as List).isNotEmpty) {
      addNewCategoryData["display_field"] =
          addNewCategoryData["rearrange_fields"].last;
    } else {
      addNewCategoryData["display_field"] = "item id";
    }

    return addNewCategoryData;
  }
}
