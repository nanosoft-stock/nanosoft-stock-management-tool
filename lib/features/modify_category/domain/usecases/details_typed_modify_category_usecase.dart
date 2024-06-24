import 'package:stock_management_tool/core/usecase/usecase.dart';

class DetailsTypedModifyCategoryUseCase extends UseCase {
  DetailsTypedModifyCategoryUseCase();

  @override
  Future call({params}) async {
    String title = params["title"];
    String value = params["value"];
    Map<String, dynamic> modifyCategoryData = params["modify_category_data"];

    String displayField = modifyCategoryData["display_field"];

    modifyCategoryData["field_details"][displayField][title] = value;

    return modifyCategoryData;
  }
}
