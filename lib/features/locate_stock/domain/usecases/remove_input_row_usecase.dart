import 'package:stock_management_tool/core/usecase/usecase.dart';

class RemoveInputRowUseCase extends UseCase {
  RemoveInputRowUseCase();

  @override
  Future call({params}) async {
    int index = params["index"];
    Map<String, dynamic> locatedStock = params["located_stock"];
    locatedStock["rows"].removeAt(index);

    return locatedStock;
  }
}
