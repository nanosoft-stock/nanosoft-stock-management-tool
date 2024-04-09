import 'package:equatable/equatable.dart';

class StockEntity extends Equatable {
  const StockEntity({
    required this.date,
    required this.category,
    required this.itemId,
    required this.serialNumber,
    required this.sku,
    required this.make,
    required this.model,
    required this.processor,
    required this.ram,
    required this.storage,
    required this.screenResolution,
    required this.os,
    required this.screenSize,
    required this.usbC,
    required this.hdmi,
    required this.displayPort,
    required this.vga,
    required this.ethernet,
    required this.usbA,
    required this.type,
    required this.supplierInfo,
    required this.dispatchInfo,
    required this.containerId,
    required this.warehouseLocation,
    required this.comments,
    required this.staff,
    required this.archived,
  });

  final DateTime date;
  final String category;
  final String itemId;
  final String serialNumber;
  final String sku;
  final String make;
  final String model;
  final String processor;
  final String ram;
  final String storage;
  final String screenResolution;
  final String os;
  final String screenSize;
  final String usbC;
  final String hdmi;
  final String displayPort;
  final String vga;
  final String ethernet;
  final String usbA;
  final String type;
  final String supplierInfo;
  final String dispatchInfo;
  final String containerId;
  final String warehouseLocation;
  final String comments;
  final String staff;
  final bool archived;

  @override
  List<Object?> get props => [
        date,
        category,
        itemId,
        serialNumber,
        sku,
        make,
        model,
        processor,
        ram,
        storage,
        screenResolution,
        os,
        screenSize,
        usbC,
        hdmi,
        displayPort,
        vga,
        ethernet,
        usbA,
        type,
        supplierInfo,
        dispatchInfo,
        containerId,
        warehouseLocation,
        comments,
        staff,
        archived,
      ];
}
