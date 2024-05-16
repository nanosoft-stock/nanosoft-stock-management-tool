import 'package:equatable/equatable.dart';

class StockFieldEntity extends Equatable {
  const StockFieldEntity({
    required this.uid,
    required this.field,
    required this.datatype,
    required this.lockable,
    required this.isWithSKU,
    required this.isTitleCase,
    required this.isBg,
    // required this.order,
    // required this.locked,
    // required this.sort,
  });

  final String uid;
  final String field;
  final String datatype;
  final bool lockable;
  final bool isWithSKU;
  final bool isTitleCase;
  final bool isBg;

  // final int order;
  // final bool locked;
  // final Sort sort;

  @override
  List<Object?> get props => [
        // uid,
        field,
        datatype,
        lockable,
        isWithSKU,
        isTitleCase,
        isBg,
        // order,
        // locked,
        // sort,
      ];
}
