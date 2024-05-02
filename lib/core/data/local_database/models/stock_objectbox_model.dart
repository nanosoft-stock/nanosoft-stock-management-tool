import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class StockObjectBoxModel {
  StockObjectBoxModel({
    this.id = 0,
    this.uid,
    required this.date,
    this.category,
    this.itemId,
    this.serialNumber,
    this.sku,
    this.make,
    this.model,
    this.processor,
    this.ram,
    this.storage,
    this.screenResolution,
    this.os,
    this.screenSize,
    this.usbC,
    this.hdmi,
    this.displayPort,
    this.vga,
    this.ethernet,
    this.usbA,
    this.type,
    this.supplierInfo,
    this.dispatchInfo,
    this.containerId,
    this.warehouseLocation,
    this.comments,
    this.staff,
    this.archived = false,
    this.updateTime,
  });

  @Id()
  int id;

  String? uid;

  @Property(type: PropertyType.date)
  DateTime date;

  String? category;
  String? itemId;
  String? serialNumber;
  String? sku;
  String? make;
  String? model;
  String? processor;
  String? ram;
  String? storage;
  String? screenResolution;
  String? os;
  String? screenSize;
  String? usbC;
  String? hdmi;
  String? displayPort;
  String? vga;
  String? ethernet;
  String? usbA;
  String? type;
  String? supplierInfo;
  String? dispatchInfo;
  String? containerId;
  String? warehouseLocation;
  String? comments;
  String? staff;
  bool? archived;

  @Property(type: PropertyType.date)
  DateTime? updateTime;

  factory StockObjectBoxModel.fromJson(Map json) {
    return StockObjectBoxModel(
      // id: json["id"] ?? 0,
      uid: json["uid"],
      date: json["date"].runtimeType == Timestamp
          ? json["date"].toDate()
          : DateTime.parse(json["date"]),
      category: json["category"],
      itemId: json["item id"],
      serialNumber: json["serial number"],
      sku: json["sku"],
      make: json["make"],
      model: json["model"],
      processor: json["processor"],
      ram: json["ram"],
      storage: json["storage"],
      screenResolution: json["screen resolution"],
      os: json["os"],
      screenSize: json["screen size"],
      usbC: json["usb c"],
      hdmi: json["hdmi"],
      displayPort: json["display port"],
      vga: json["vga"],
      ethernet: json["ethernet"],
      usbA: json["usb a"],
      type: json["type"],
      supplierInfo: json["supplier info"],
      dispatchInfo: json["dispatch info"],
      containerId: json["container id"],
      warehouseLocation: json["warehouse location"],
      comments: json["comments"],
      staff: json["staff"],
      archived: json["archived"],
      updateTime: json["update time"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "date": date,
      "category": category,
      "item id": itemId,
      "serial number": serialNumber,
      "sku": sku,
      "make": make,
      "model": model,
      "processor": processor,
      "ram": ram,
      "storage": storage,
      "screen resolution": screenResolution,
      "os": os,
      "screen size": screenSize,
      "usb c": usbC,
      "hdmi": hdmi,
      "display port": displayPort,
      "vga": vga,
      "ethernet": ethernet,
      "usb a": usbA,
      "type": type,
      "supplier info": supplierInfo,
      "dispatch info": dispatchInfo,
      "container id": containerId,
      "warehouse location": warehouseLocation,
      "comments": comments,
      "staff": staff,
      "archived": archived,
      "update time": updateTime,
    };
  }

  @override
  String toString() {
    return "StockModel(date: $date, uid: $uid, category: $category, itemId: $itemId, serialNumber: $serialNumber, sku: $sku, make: $make, model: $model, processor: $processor, ram: $ram, storage: $storage, screenResolution: $screenResolution, os: $os, screenSize: $screenSize, usbC: $usbC, hdmi: $hdmi, displayPort: $displayPort, vga: $vga, ethernet: $ethernet, usbA: $usbA, type: $type, supplierInfo: $supplierInfo, dispatchInfo: $dispatchInfo, containerId: $containerId, warehouseLocation: $warehouseLocation, comments: $comments, staff: $staff, archived: $archived, updateTime: $updateTime)";
  }
}
