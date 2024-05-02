import 'package:equatable/equatable.dart';

class StockInputFieldEntity extends Equatable {
  const StockInputFieldEntity({
    required this.uid,
    required this.field,
    required this.datatype,
    required this.lockable,
    required this.isWithSKU,
    required this.isTitleCase,
    required this.isBg,
    required this.order,
    required this.items,
    required this.textValue,
    required this.locked,
  });

  final String uid;
  final String field;
  final String datatype;
  final bool lockable;
  final bool isWithSKU;
  final bool isTitleCase;
  final bool isBg;
  final int order;
  final List items;
  final String textValue;
  final bool locked;

  @override
  List<Object?> get props => [
        uid,
        field,
        datatype,
        lockable,
        isWithSKU,
        isTitleCase,
        isBg,
        order,
        items,
        textValue,
        locked,
      ];
}
