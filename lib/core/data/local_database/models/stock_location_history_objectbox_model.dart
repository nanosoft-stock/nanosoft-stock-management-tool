import 'package:objectbox/objectbox.dart';

@Entity()
class StockLocationHistoryObjectBoxModel {
  StockLocationHistoryObjectBoxModel({
    this.id = 0,
    required this.date,
    this.itemId,
    this.containerId,
    this.warehouseLocation,
    this.comments,
    this.staff,
  });

  @Id()
  int id;

  @Property(type: PropertyType.date)
  DateTime date;

  String? itemId;
  String? containerId;
  String? warehouseLocation;
  String? comments;
  String? staff;
}
