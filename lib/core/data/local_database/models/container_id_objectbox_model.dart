import 'package:objectbox/objectbox.dart';

@Entity()
class ContainerIdObjectBoxModel {
  ContainerIdObjectBoxModel({
    this.id = 0,
    required this.containerId,
  });

  @Id()
  int id;

  String? containerId;

  factory ContainerIdObjectBoxModel.fromJson(Map json) {
    return ContainerIdObjectBoxModel(
      containerId: json["container_id"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "container_id": containerId,
    };
  }

  @override
  String toString() {
    return "ContainerIdObjectBoxModel(id:$id, container_id:$containerId)";
  }
}
