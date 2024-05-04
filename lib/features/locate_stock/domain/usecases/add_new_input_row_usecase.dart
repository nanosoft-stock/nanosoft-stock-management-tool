import 'package:stock_management_tool/core/usecase/usecase.dart';

class AddNewInputRowUseCase extends UseCase {
  AddNewInputRowUseCase();

  @override
  Future call({params}) async {
    Map<String, dynamic> locatedStock = params["located_stock"];
    locatedStock["rows"].add({"search_by": "", "show_table": true});

    return locatedStock;
  }
}
