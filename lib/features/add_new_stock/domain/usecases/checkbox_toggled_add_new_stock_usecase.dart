import 'package:stock_management_tool/core/usecase/usecase.dart';

class CheckboxToggledAddNewStockUseCase extends UseCase {
  CheckboxToggledAddNewStockUseCase();

  @override
  Future call({params}) async {
    String field = params["field"];
    bool value = params["value"];
    List<Map<String, dynamic>> fields = params["fields"];

    fields.firstWhere((e) => e["field"] == field)["is_disabled"] = value;

    return fields;
  }
}
