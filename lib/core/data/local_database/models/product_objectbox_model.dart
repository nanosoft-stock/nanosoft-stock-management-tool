import 'package:objectbox/objectbox.dart';

@Entity()
class ProductObjectBoxModel {
  ProductObjectBoxModel({
    this.id = 0,
    this.uid,
    this.category,
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
    this.updateTime,
  });

  @Id()
  int id;

  String? uid;
  String? category;
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

  @Property(type: PropertyType.date)
  DateTime? updateTime;

  factory ProductObjectBoxModel.fromJson(Map json) {
    return ProductObjectBoxModel(
      uid: json['uid'],
      category: json['category'],
      sku: json['sku'],
      make: json['make'],
      model: json['model'],
      processor: json['processor'],
      ram: json['ram'],
      storage: json['storage'],
      screenResolution: json['screen resolution'],
      os: json['os'],
      screenSize: json['screen size'],
      usbC: json['usb c'],
      hdmi: json['hdmi'],
      displayPort: json['display port'],
      vga: json['vga'],
      ethernet: json['ethernet'],
      usbA: json['usb a'],
      type: json['type'],
      updateTime: json['update time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'category': category,
      'sku': sku,
      'make': make,
      'model': model,
      'processor': processor,
      'ram': ram,
      'storage': storage,
      'screen resolution': screenResolution,
      'os': os,
      'screen size': screenSize,
      'usb c': usbC,
      'hdmi': hdmi,
      'display port': displayPort,
      'vga': vga,
      'ethernet': ethernet,
      'usb a': usbA,
      'type': type,
      'update time': updateTime,
    };
  }

  @override
  String toString() {
    return "ProductModel(id:$id, uid:$uid, category:$category, sku:$sku, make:$make, model:$model, processor:$processor, ram:$ram, storage:$storage, screenResolution:$screenResolution, os:$os, screenSize:$screenSize, usbC:$usbC, hdmi:$hdmi, displayPort:$displayPort, vga:$vga, ethernet:$ethernet, usbA:$usbA, type:$type, updateTime:$updateTime)";
  }
}
