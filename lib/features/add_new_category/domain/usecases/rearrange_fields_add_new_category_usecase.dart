import 'package:stock_management_tool/core/usecase/usecase.dart';

class RearrangeFieldsAddNewCategoryUseCase extends UseCase {
  RearrangeFieldsAddNewCategoryUseCase();

  @override
  Future call({params}) async {
    List fields = params["fields"];
    Map<String, dynamic> addNewCategoryData = params["add_new_category_data"];

    addNewCategoryData["rearrange_fields"] = fields;

    return addNewCategoryData;
  }
}
