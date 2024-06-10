import 'package:stock_management_tool/core/usecase/usecase.dart';

class FieldFilterSelectedUseCase extends UseCase {
  FieldFilterSelectedUseCase();

  @override
  Future call({params}) async {
    int index = params["index"];
    String field = params["field"];
    Map<String, dynamic> locatedStock = params["located_stock"];

    locatedStock["rows"][index]["filter_field"] = field;
    locatedStock["layers"].remove("parent_filter_overlay");
    locatedStock["layers"].add("field_filter_overlay");

    return locatedStock;
  }
}
