import 'package:equatable/equatable.dart';
import 'package:stock_management_tool/constants/enums.dart';

class StockFieldEntity extends Equatable {
  const StockFieldEntity({
    required this.field,
    required this.datatype,
    required this.lockable,
    required this.isWithSKU,
    required this.isTitleCase,
    required this.isBg,
    // required this.order,
    // required this.locked,
    required this.sort,
  });

  final String field;
  final String datatype;
  final bool lockable;
  final bool isWithSKU;
  final bool isTitleCase;
  final bool isBg;

  // final int order;
  // final bool locked;
  final Sort sort;

  @override
  List<Object?> get props => [
        field,
        datatype,
        lockable,
        isWithSKU,
        isTitleCase,
        isBg,
        // order,
        // locked,
        sort,
      ];
}
