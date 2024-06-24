import 'package:stock_management_tool/core/usecase/usecase.dart';

class RemoveFieldModifyCategoryUseCase extends UseCase {
  RemoveFieldModifyCategoryUseCase();

  @override
  Future call({params}) async {
    Map<String, dynamic> modifyCategoryData = params["modify_category_data"];

    String displayField = modifyCategoryData["display_field"];

    modifyCategoryData["field_details"].remove(displayField);
    int index = modifyCategoryData["rearrange_fields"].indexOf(displayField);
    modifyCategoryData["rearrange_fields"].remove(displayField);

    if ((modifyCategoryData["rearrange_fields"] as List).isNotEmpty) {
      modifyCategoryData["display_field"] = index >= 1
          ? modifyCategoryData["rearrange_fields"][index - 1]
          : "item id";
    } else {
      modifyCategoryData["display_field"] = "item id";
    }

    return modifyCategoryData;
  }
}
