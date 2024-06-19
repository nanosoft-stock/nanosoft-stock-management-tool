import 'package:equatable/equatable.dart';

class StockEntity extends Equatable {
  const StockEntity({
    required this.uid,
    required this.date,
    required this.category,
    required this.itemId,
    required this.containerId,
    required this.warehouseLocationId,
    required this.fields,
    required this.values,
  });

  final String uid;
  final DateTime date;
  final String category;
  final String itemId;
  final String containerId;
  final String warehouseLocationId;

  final List<String> fields;
  final List<String> values;

  @override
  List<Object?> get props => [
        itemId,
      ];
}
