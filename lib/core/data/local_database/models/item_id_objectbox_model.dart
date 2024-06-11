import 'package:objectbox/objectbox.dart';

@Entity()
class ItemIdObjectBoxModel {
  ItemIdObjectBoxModel({
    this.id = 0,
    required this.itemId,
    required this.containerId,
    required this.docRef,
  });

  @Id()
  int id;

  String? itemId;
  String? containerId;
  String? docRef;

  factory ItemIdObjectBoxModel.fromJson(Map json) {
    return ItemIdObjectBoxModel(
      itemId: json["item_id"],
      containerId: json["container_id"],
      docRef: json["doc_ref"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "item_id": itemId,
      "container_id": containerId,
      "doc_ref": docRef,
    };
  }

  @override
  String toString() {
    return "ItemIdObjectBoxModel(id:$id, item_id:$itemId, container_id:$containerId, doc_ref:$docRef)";
  }
}
