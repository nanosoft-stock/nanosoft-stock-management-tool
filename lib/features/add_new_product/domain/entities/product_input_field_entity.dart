import 'package:equatable/equatable.dart';

class ProductInputFieldEntity extends Equatable {
  const ProductInputFieldEntity({
    required this.field,
    required this.datatype,
    required this.items,
    required this.nameCase,
    required this.valueCase,
    required this.order,
    required this.textValue,
  });

  final String? field;
  final String? datatype;
  final List<String>? items;
  final String? nameCase;
  final String? valueCase;
  final int? order;
  final String? textValue;

  @override
  List<Object?> get props => [
        field,
      ];
}
