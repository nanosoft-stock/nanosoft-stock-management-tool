import 'package:stock_management_tool/core/usecase/usecase.dart';

class ViewFieldDetailsModifyCategoryUseCase extends UseCase {
  ViewFieldDetailsModifyCategoryUseCase();

  @override
  Future call({params}) async {
    String field = params["field"];
    Map<String, dynamic> modifyCategoryData = params["modify_category_data"];

    modifyCategoryData["display_field"] = field;

    return modifyCategoryData;
  }
}
