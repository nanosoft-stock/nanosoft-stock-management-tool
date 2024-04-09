import 'package:objectbox/objectbox.dart';

@Entity()
class StockModel {
  StockModel({
    this.id = 0,
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
}
