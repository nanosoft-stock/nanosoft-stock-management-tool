import 'package:equatable/equatable.dart';

class ProductInputFieldEntity extends Equatable {
  const ProductInputFieldEntity({
    required this.uid,
    required this.field,
    required this.datatype,
    required this.isWithSKU,
    required this.isTitleCase,
    required this.items,
    required this.textValue,
  });

  final String uid;
  final String field;
  final String datatype;
  final bool isWithSKU;
  final bool isTitleCase;
  final List items;
  final String? textValue;

  @override
  List<Object?> get props => [
        uid,
        field,
        datatype,
        isWithSKU,
        isTitleCase,
        items,
        textValue,
      ];
}
