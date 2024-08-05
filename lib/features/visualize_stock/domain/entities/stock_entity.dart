import 'package:equatable/equatable.dart';

class StockEntity extends Equatable {
  const StockEntity({
    this.date,
    this.category,
    this.sku,
    this.serialNumber,
    this.itemId,
    this.containerId,
    this.warehouseLocationId,
    this.supplierInfo,
    this.comments,
    this.username,
    this.specifications,
  });

  final DateTime? date;
  final String? category;
  final String? sku;
  final String? serialNumber;
  final String? itemId;
  final String? containerId;
  final String? warehouseLocationId;
  final String? supplierInfo;
  final String? comments;
  final String? username;
  final Map<String, dynamic>? specifications;

  @override
  List<Object?> get props => [
        itemId,
      ];
}
