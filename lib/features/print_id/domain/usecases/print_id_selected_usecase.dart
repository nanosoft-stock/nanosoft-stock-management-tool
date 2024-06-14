import 'package:stock_management_tool/core/usecase/usecase.dart';

class PrintIdSelectedUseCase extends UseCase {
  PrintIdSelectedUseCase();

  @override
  Future call({params}) async {
    String printableId = params["printable_id"];
    Map<String, dynamic> printIdData = params["print_id_data"];

    printIdData["printable_id"] = printableId;

    return printIdData;
  }
}
