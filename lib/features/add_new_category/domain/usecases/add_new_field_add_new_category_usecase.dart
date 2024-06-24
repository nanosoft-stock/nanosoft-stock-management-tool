import 'package:stock_management_tool/core/usecase/usecase.dart';

class AddNewFieldAddNewCategoryUseCase extends UseCase {
  AddNewFieldAddNewCategoryUseCase();

  @override
  Future call({params}) async {
    Map<String, dynamic> addNewCategoryData = params["add_new_category_data"];

    if (!addNewCategoryData["rearrange_fields"].contains("")) {
      addNewCategoryData["rearrange_fields"].add("");

      addNewCategoryData["field_details"][""] = {
        "field": "",
        "datatype": "",
        "in_sku": "",
        "is_background": "",
        "is_lockable": "",
        "name_case": "",
        "value_case": "",
        "can_edit": true,
        "can_remove": true,
      };
    }

    return addNewCategoryData;
  }
}
