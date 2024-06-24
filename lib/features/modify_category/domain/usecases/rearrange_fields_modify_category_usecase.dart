import 'package:stock_management_tool/core/usecase/usecase.dart';

class RearrangeFieldsModifyCategoryUseCase extends UseCase {
  RearrangeFieldsModifyCategoryUseCase();

  @override
  Future call({params}) async {
    List fields = params["fields"];
    Map<String, dynamic> modifyCategoryData = params["modify_category_data"];

    modifyCategoryData["rearrange_fields"] = fields;

    return modifyCategoryData;
  }
}
