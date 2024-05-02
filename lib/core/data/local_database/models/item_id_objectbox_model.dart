import 'package:objectbox/objectbox.dart';

@Entity()
class ItemIdObjectBoxModel {
  ItemIdObjectBoxModel({
    this.id = 0,
    required this.itemId,
  });

  @Id()
  int id;

  String? itemId;

  factory ItemIdObjectBoxModel.fromJson(Map json) {
    return ItemIdObjectBoxModel(
      itemId: json["item_id"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "item_id": itemId,
    };
  }

  @override
  String toString() {
    return "ItemIdObjectBoxModel(id:$id, item_id:$itemId)";
  }
}
