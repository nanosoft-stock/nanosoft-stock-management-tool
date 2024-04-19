import 'package:stock_management_tool/core/usecase/usecase.dart';

class IdSelectedUseCase extends UseCase {
  IdSelectedUseCase();

  @override
  Future call({params}) async {
    int index = params["index"];
    String id = params["id"];
    List<Map<String, dynamic>> locatedItems = params["located items"];
    if (locatedItems[index]["id"] == null) {
      locatedItems[index]["id"] = [id];
    } else {
      locatedItems[index]["id"] = [...locatedItems[index]["id"], id];
    }

    return locatedItems;
  }
}
