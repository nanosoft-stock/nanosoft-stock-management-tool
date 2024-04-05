import 'package:equatable/equatable.dart';

class ProductInputFieldEntity extends Equatable {
  ProductInputFieldEntity(
      {required this.field,
      required this.datatype,
      required this.isWithSKU,
      required this.isTitleCase,
      required this.items,
      this.textValue});

  final String field;
  final String datatype;
  final bool isWithSKU;
  final bool isTitleCase;
  final List items;
  String? textValue;

  @override
  List<Object?> get props => [field, datatype, isWithSKU, isTitleCase, items, textValue];
}
