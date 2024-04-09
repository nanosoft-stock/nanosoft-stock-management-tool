import 'package:stock_management_tool/features/visualize_stock/domain/entities/stock_entity.dart';

class StockModel extends StockEntity {
  const StockModel({
    required super.date,
    required super.category,
    required super.itemId,
    required super.serialNumber,
    required super.sku,
    required super.make,
    required super.model,
    required super.processor,
    required super.ram,
    required super.storage,
    required super.screenResolution,
    required super.os,
    required super.screenSize,
    required super.usbC,
    required super.hdmi,
    required super.displayPort,
    required super.vga,
    required super.ethernet,
    required super.usbA,
    required super.type,
    required super.supplierInfo,
    required super.dispatchInfo,
    required super.containerId,
    required super.warehouseLocation,
    required super.comments,
    required super.staff,
    required super.archived,
  });

  factory StockModel.fromJson(Map<String, dynamic> json) {
    return StockModel(
      date: json["date"],
      category: json["category"] ?? "",
      itemId: json["item id"] ?? "",
      serialNumber: json["serial number"] ?? "",
      sku: json["sku"] ?? "",
      make: json["make"] ?? "",
      model: json["model"] ?? "",
      processor: json["processor"] ?? "",
      ram: json["ram"] ?? "",
      storage: json["storage"] ?? "",
      screenResolution: json["screen resolution"] ?? "",
      os: json["os"] ?? "",
      screenSize: json["screen size"] ?? "",
      usbC: json["usb c"] ?? "",
      hdmi: json["hdmi"] ?? "",
      displayPort: json["display port"] ?? "",
      vga: json["vga"] ?? "",
      ethernet: json["ethernet"] ?? "",
      usbA: json["usb a"] ?? "",
      type: json["type"] ?? "",
      supplierInfo: json["supplier info"] ?? "",
      dispatchInfo: json["dispatch info"] ?? "",
      containerId: json["container id"] ?? "",
      warehouseLocation: json["warehouse location"] ?? "",
      comments: json["comments"] ?? "",
      staff: json["staff"] ?? "",
      archived: json["archived"] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
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
      "usbA": usbA,
      "type": type,
      "supplier info": supplierInfo,
      "dispatch info": dispatchInfo,
      "container id": containerId,
      "warehouse location": warehouseLocation,
      "comments": comments,
      "staff": staff,
      "archived": archived,
    };
  }

  StockModel copyWith({
    DateTime? date,
    String? category,
    String? itemId,
    String? serialNumber,
    String? sku,
    String? make,
    String? model,
    String? processor,
    String? ram,
    String? storage,
    String? screenResolution,
    String? os,
    String? screenSize,
    String? usbC,
    String? hdmi,
    String? displayPort,
    String? vga,
    String? ethernet,
    String? usbA,
    String? type,
    String? supplierInfo,
    String? dispatchInfo,
    String? containerId,
    String? warehouseLocation,
    String? comments,
    String? staff,
    bool? archived,
  }) {
    return StockModel(
      date: date ?? this.date,
      category: category ?? this.category,
      itemId: itemId ?? this.itemId,
      serialNumber: serialNumber ?? this.serialNumber,
      sku: sku ?? this.sku,
      make: make ?? this.make,
      model: model ?? this.model,
      processor: processor ?? this.processor,
      ram: ram ?? this.ram,
      storage: storage ?? this.storage,
      screenResolution: screenResolution ?? this.screenResolution,
      os: os ?? this.os,
      screenSize: screenSize ?? this.screenSize,
      usbC: usbC ?? this.usbC,
      hdmi: hdmi ?? this.hdmi,
      displayPort: displayPort ?? this.displayPort,
      vga: vga ?? this.vga,
      ethernet: ethernet ?? this.ethernet,
      usbA: usbA ?? this.usbA,
      type: type ?? this.type,
      supplierInfo: supplierInfo ?? this.supplierInfo,
      dispatchInfo: dispatchInfo ?? this.dispatchInfo,
      containerId: containerId ?? this.containerId,
      warehouseLocation: warehouseLocation ?? this.warehouseLocation,
      comments: comments ?? this.comments,
      staff: staff ?? this.staff,
      archived: archived ?? this.archived,
    );
  }
}
