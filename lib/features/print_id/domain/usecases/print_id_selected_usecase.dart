import 'package:stock_management_tool/core/usecase/usecase.dart';

class PrintIdSelectedUseCase extends UseCase {
  PrintIdSelectedUseCase();

  @override
  Future call({params}) async {
    String printId = params["print_id"];
    Map<String, dynamic> printIdData = params["print_id_data"];

    printIdData["print_id"] = printId;

    return printIdData;
  }
}
