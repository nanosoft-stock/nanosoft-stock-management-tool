import 'package:stock_management_tool/core/usecase/usecase.dart';
import 'package:stock_management_tool/features/print_id/domain/repositories/print_id_repository.dart';

class PrintPressedUseCase extends UseCase {
  PrintPressedUseCase(this._printIdRepository);

  final PrintIdRepository _printIdRepository;

  @override
  Future call({params}) async {
    Map<String, dynamic> printIdData = params["print_id_data"];

    printIdData["new_ids"] = await _printIdRepository.getIds(
      printIdData["print_id"],
      printIdData["print_count"],
    );

    if (printIdData["print_id"] == "Item Id") {
      await _printIdRepository.printItemIds(
        printIdData["new_ids"] as List<String>,
      );
    } else if (printIdData["print_id"] == "Container Id") {
      await _printIdRepository.printContainerIds(
        printIdData["new_ids"] as List<String>,
      );
    }

    return printIdData;
  }
}
