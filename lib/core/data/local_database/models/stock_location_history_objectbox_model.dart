import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class StockLocationHistoryObjectBoxModel {
  StockLocationHistoryObjectBoxModel({
    this.id = 0,
    this.uid,
    required this.date,
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
      items: json["items"].cast<String>(),
      containerId: json["containerId"],
      warehouseLocationId: json["warehouseLocationId"],
      moveType: json["moveType"],
      state: json["state"],
      staff: json["staff"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "date": date,
      "items": items,
      "containerId": containerId,
      "warehouseLocationId": warehouseLocationId,
      "moveType": moveType,
      "state": state,
      "staff": staff,
    };
  }

  @override
  String toString() {
    return "StockLocationHistory(date: $date, uid: $uid, items: $items, containerId: $containerId, warehouseLocationId: $warehouseLocationId, moveType: $moveType, state: $state, staff: $state)";
  }
}
