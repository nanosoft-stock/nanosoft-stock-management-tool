import 'package:objectbox/objectbox.dart';

@Entity()
class ProductModel {
  ProductModel({
    this.id = 0,
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

  factory ProductModel.fromJson(Map json) {
    return ProductModel(
      category: json['category'],
      sku: json['sku'],
      make: json['make'],
      model: json['model'],
      processor: json['processor'],
      ram: json['ram'],
      storage: json['storage'],
      screenResolution: json['screenResolution'],
      os: json['os'],
      screenSize: json['screenSize'],
      usbC: json['usbC'],
      hdmi: json['hdmi'],
      displayPort: json['displayPort'],
      vga: json['vga'],
      ethernet: json['ethernet'],
      usbA: json['usbA'],
      type: json['type'],
      updateTime: json['updateTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'sku': sku,
      'make': make,
      'model': model,
      'processor': processor,
      'ram': ram,
      'storage': storage,
      'screenResolution': screenResolution,
      'os': os,
      'screenSize': screenSize,
      'usbC': usbC,
      'hdmi': hdmi,
      'displayPort': displayPort,
      'vga': vga,
      'ethernet': ethernet,
      'usbA': usbA,
      'type': type,
      'updateTime': updateTime,
    };
  }

  @override
  String toString() {
    return "ProductModel(id:$id, category:$category, sku:$sku, make:$make, model:$model, processor:$processor, ram:$ram, storage:$storage, screenResolution:$screenResolution, os:$os, screenSize:$screenSize, usbC:$usbC, hdmi:$hdmi, displayPort:$displayPort, vga:$vga, ethernet:$ethernet, usbA:$usbA, type:$type, updateTime:$updateTime)";
  }
}
