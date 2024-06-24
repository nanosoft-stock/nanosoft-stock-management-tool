import 'package:stock_management_tool/core/usecase/usecase.dart';

class AddNewFieldModifyCategoryUseCase extends UseCase {
  AddNewFieldModifyCategoryUseCase();

  @override
  Future call({params}) async {
    Map<String, dynamic> modifyCategoryData = params["modify_category_data"];

    if (!modifyCategoryData["rearrange_fields"].contains("")) {
      modifyCategoryData["rearrange_fields"].add("");

      modifyCategoryData["field_details"][""] = {
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

    return modifyCategoryData;
  }
}
