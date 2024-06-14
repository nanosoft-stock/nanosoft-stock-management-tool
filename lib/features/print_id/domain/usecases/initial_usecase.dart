import 'package:stock_management_tool/core/usecase/usecase.dart';

class InitialPrintIdUseCase extends UseCase {
  InitialPrintIdUseCase();

  @override
  Future call({params}) async {
    Map<String, dynamic> printIdData = {
      "print_id": "",
      "printable_ids": const [
        "Item Id",
        "Container Id",
      ],
      "print_count": "",
      "new_ids": null,
    };

    return printIdData;
  }
}
