import 'package:stock_management_tool/core/usecase/usecase.dart';

class SwitchTableViewUseCase extends UseCase {
  SwitchTableViewUseCase();

  @override
  Future call({params}) async {
    int index = params["index"];
    bool showTable = params["show_table"];
    Map<String, dynamic> locatedStock = params["located_stock"];

    locatedStock["rows"][index]["show_table"] = showTable;

    return locatedStock;
  }
}
