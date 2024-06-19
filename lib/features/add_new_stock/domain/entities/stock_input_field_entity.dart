import 'package:equatable/equatable.dart';

class StockInputFieldEntity extends Equatable {
  const StockInputFieldEntity({
    required this.field,
    required this.category,
    required this.datatype,
    required this.inSku,
    required this.isBackground,
    required this.isLockable,
    required this.items,
    required this.nameCase,
    required this.valueCase,
    required this.order,
    required this.isDisabled,
    required this.textValue,
  });

  final String? field;
  final String? category;
  final String? datatype;
  final bool? inSku;
  final bool? isBackground;
  final bool? isLockable;
  final List<String>? items;
  final String? nameCase;
  final String? valueCase;
  final int? order;
  final bool? isDisabled;
  final String? textValue;

  @override
  List<Object?> get props => [
        field,
      ];
}
