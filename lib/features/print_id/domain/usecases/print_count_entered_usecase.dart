import 'package:stock_management_tool/core/usecase/usecase.dart';

class PrintCountEnteredUseCase extends UseCase {
  PrintCountEnteredUseCase();

  @override
  Future call({params}) async {
    String count = params["print_count"];
    Map<String, dynamic> printIdData = params["print_id_data"];

    printIdData["print_count"] = count;

    return printIdData;
  }
}
