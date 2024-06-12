import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class StockLocationHistoryObjectBoxModel {
  StockLocationHistoryObjectBoxModel({
    this.id = 0,
    this.uid,
    required this.date,
    this.groupId,
    this.items,
    this.containerId,
    this.warehouseLocationId,
    this.moveType,
    this.state,
    this.staff,
  });

  @Id()
  int id;

  String? uid;

  @Property(type: PropertyType.date)
  DateTime date;

  String? groupId;
  List<String>? items;
  String? containerId;
  String? warehouseLocationId;
  String? moveType;
  String? state;
  String? staff;

  factory StockLocationHistoryObjectBoxModel.fromJson(Map json) {
    return StockLocationHistoryObjectBoxModel(
      uid: json["uid"],
      date: json["date"].runtimeType == Timestamp
          ? json["date"].toDate()
          : DateTime.parse(json["date"]),
      groupId: json["group_id"],
      items: json["items"].cast<String>(),
      containerId: json["container_id"],
      warehouseLocationId: json["warehouse_location_id"],
      moveType: json["move_type"],
      state: json["state"],
      staff: json["staff"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "date": date,
      "group_id": groupId,
      "items": items,
      "container_id": containerId,
      "warehouse_location_id": warehouseLocationId,
      "move_type": moveType,
      "state": state,
      "staff": staff,
    };
  }

  @override
  String toString() {
    return "StockLocationHistory(uid: $uid, date: $date, group_id: $groupId, items: $items, containerId: $containerId, warehouseLocationId: $warehouseLocationId, moveType: $moveType, state: $state, staff: $state)";
  }
}
