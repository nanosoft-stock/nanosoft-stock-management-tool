import 'package:stock_management_tool/core/usecase/usecase.dart';

class IdEnteredUseCase extends UseCase {
  IdEnteredUseCase();

  @override
  Future call({params}) async {
    int index = params["index"];
    String chosenId = params["chosen_id"];
    Map<String, dynamic> locatedStock = params["located_stock"];

    List chosenIds = locatedStock["rows"][index]["chosen_ids"];
    chosenIds.add(chosenId);
    chosenIds = chosenIds.toSet().toList();
    chosenIds.sort((a, b) => a.compareTo(b));

    locatedStock["rows"][index]["chosen_ids"] = chosenIds;

    return locatedStock;
  }
}
