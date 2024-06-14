import 'package:objectbox/objectbox.dart';

@Entity()
class ItemIdObjectBoxModel {
  ItemIdObjectBoxModel({
    this.id = 0,
    required this.itemId,
    required this.containerId,
    required this.docRef,
    required this.status,
  });

  @Id()
  int id;

  String? itemId;
  String? containerId;
  String? docRef;
  String? status;

  factory ItemIdObjectBoxModel.fromJson(Map json) {
    return ItemIdObjectBoxModel(
      itemId: json["item_id"],
      containerId: json["container_id"],
      docRef: json["doc_ref"],
      status: json["status"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "item_id": itemId,
      "container_id": containerId,
      "doc_ref": docRef,
      "status": status,
    };
  }

  @override
  String toString() {
    return "ItemIdObjectBoxModel(id:$id, item_id:$itemId, container_id:$containerId, doc_ref:$docRef, status: $status)";
  }
}
