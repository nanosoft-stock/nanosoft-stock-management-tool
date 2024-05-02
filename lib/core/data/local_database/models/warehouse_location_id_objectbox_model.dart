import 'package:objectbox/objectbox.dart';

@Entity()
class WarehouseLocationIdObjectBoxModel {
  WarehouseLocationIdObjectBoxModel({
    this.id = 0,
    required this.warehouseLocationId,
  });

  @Id()
  int id;

  String? warehouseLocationId;

  factory WarehouseLocationIdObjectBoxModel.fromJson(Map json) {
    return WarehouseLocationIdObjectBoxModel(
      warehouseLocationId: json["warehouse_location_id"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "warehouse_location_id": warehouseLocationId,
    };
  }

  @override
  String toString() {
    return "WarehouseLocationIdObjectBoxModel(id:$id, warehouse_location_id:$warehouseLocationId)";
  }
}
