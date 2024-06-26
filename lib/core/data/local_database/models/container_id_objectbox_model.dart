import 'package:objectbox/objectbox.dart';

@Entity()
class ContainerIdObjectBoxModel {
  ContainerIdObjectBoxModel({
    this.id = 0,
    required this.containerId,
    required this.status,
    required this.warehouseLocationId,
  });

  @Id()
  int id;

  String? containerId;
  String? status;
  String? warehouseLocationId;

  factory ContainerIdObjectBoxModel.fromJson(Map json) {
    return ContainerIdObjectBoxModel(
      containerId: json["container_id"],
      status: json["status"],
      warehouseLocationId: json["warehouse_location_id"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "container_id": containerId,
      "status": status,
      "warehouse_location_id": warehouseLocationId,
    };
  }

  @override
  String toString() {
    return "ContainerIdObjectBoxModel(id:$id, container_id:$containerId, status: $status, warehouse_location_id:$warehouseLocationId)";
  }
}
