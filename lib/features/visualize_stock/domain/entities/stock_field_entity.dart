import 'package:equatable/equatable.dart';

class StockFieldEntity extends Equatable {
  const StockFieldEntity({
    required this.field,
    required this.datatype,
    required this.lockable,
    required this.isWithSKU,
    required this.isTitleCase,
    required this.isBg,
    // required this.order,
    required this.locked,
  });

  final String field;
  final String datatype;
  final bool lockable;
  final bool isWithSKU;
  final bool isTitleCase;
  final bool isBg;

  // final int order;
  final bool locked;

  @override
  List<Object?> get props => [
        field,
        datatype,
        lockable,
        isWithSKU,
        isTitleCase,
        isBg,
        // order,
        locked,
      ];
}
