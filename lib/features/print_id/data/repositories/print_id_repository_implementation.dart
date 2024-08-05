import 'package:barcode/barcode.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:stock_management_tool/core/constants/constants.dart';
import 'package:stock_management_tool/core/local_database/local_database.dart';
import 'package:stock_management_tool/core/services/firestore.dart';
import 'package:stock_management_tool/features/print_id/domain/repositories/print_id_repository.dart';
import 'package:stock_management_tool/core/services/injection_container.dart';

class PrintIdRepositoryImplementation implements PrintIdRepository {
  PrintIdRepositoryImplementation(this._localDB);

  final LocalDatabase _localDB;

  @override
  Future<List<String>> getIds(String printableId, String countString) async {
    int? count = int.tryParse(countString);

    if (count != null && countString != "0") {
      if (printableId == "Item Id") {
        Map items = {};
        _localDB.items.forEach((e) {
          items[e.itemId] = e.toMap()..remove("item_id");
        });

        List itemIds = items.entries
            .where((e) => e.value["status"] != "chosen")
            .map((e) => e.key)
            .toList()
          ..sort((a, b) => a.compareTo(b));

        int lastId = int.tryParse(itemIds.last) ?? 0;

        List<String> newItemIds = [];
        for (int i = 0; i < count; i++) {
          do {
            lastId += 1;
          } while (items[lastId.toString().padLeft(8, "0")] != null);

          newItemIds.add(lastId.toString().padLeft(8, "0"));
          items[lastId.toString().padLeft(8, "0")] = {"status": "chosen"};
        }

        await _addNewLocation(
            locations: items, uid: itemIdUid, updateField: "item_id");

        return newItemIds;
      } else if (printableId == "Container Id") {
        Map containers = {};
        _localDB.containers.forEach((e) {
          containers[e.containerId] = e.toMap()..remove("container_id");
        });

        List containerIds = containers.entries
            .where((e) => e.value["status"] != "chosen")
            .map((e) => e.key)
            .toList()
          ..sort((a, b) => a.compareTo(b));

        int lastId = int.tryParse(containerIds.last) ?? 0;

        List<String> newContainerIds = [];
        for (int i = 0; i < count; i++) {
          do {
            lastId += 1;
          } while (
              containers["ST${lastId.toString().padLeft(7, "0")}"] != null);

          newContainerIds.add("ST${lastId.toString().padLeft(7, "0")}");
          containers["ST${lastId.toString().padLeft(7, "0")}"] = {
            "status": "chosen"
          };
        }

        await _addNewLocation(
            locations: containers,
            uid: containerIdUid,
            updateField: "container_id");

        return newContainerIds;
      }
    }

    return [];
  }

  Future<void> _addNewLocation({
    required Map locations,
    required String uid,
    required String updateField,
  }) async {
    Map data = {};

    List tempLocations = locations.keys.toSet().toList();

    for (String e in tempLocations) {
      if (updateField == "container_id") {
        data[e] = {
          "status": locations[e]["status"] ?? "",
          "warehouse_location_id": locations[e]["warehouse_location_id"] ?? "",
        };
      } else if (updateField == "item_id") {
        data[e] = {
          "container_id": locations[e]["container_id"] ?? "",
          "doc_ref": locations[e]["doc_ref"] ?? "",
          "status": locations[e]["status"] ?? "",
        };
      }
    }

    await sl.get<Firestore>().modifyDocument(
          path: "unique_values",
          uid: uid,
          updateMask: [updateField],
          data: !kIsLinux
              ? {
                  updateField: data,
                }
              : {
                  updateField: {
                    "mapValue": {
                      "fields": {
                        data.map(
                          (k, v) => MapEntry(
                            k,
                            v != null
                                ? {
                                    "mapValue": {
                                      "fields": v.map(
                                        (k1, v1) => MapEntry(
                                          k1,
                                          {
                                            "stringValue": v1,
                                          },
                                        ),
                                      ),
                                    },
                                  }
                                : null,
                          ),
                        )
                      }
                    }
                  }
                },
        );
  }

  @override
  Future<void> printItemIds(List<String> newIds) async {
    final pw.Document doc = pw.Document();
    final barcode = Barcode.code128();

    for (String id in newIds) {
      final svgBarcode = barcode.toSvg(id,
          width: 5.0 * PdfPageFormat.cm, height: 2.5 * PdfPageFormat.cm);

      doc.addPage(
        pw.Page(
          orientation: pw.PageOrientation.natural,
          pageFormat: const PdfPageFormat(
              5.0 * PdfPageFormat.cm, 2.5 * PdfPageFormat.cm),
          build: (pw.Context context) {
            return pw.Center(
              child: pw.SvgImage(
                svg: svgBarcode,
                width: 4.75 * PdfPageFormat.cm,
                height: 2.25 * PdfPageFormat.cm,
              ),
            );
          },
        ),
      );
    }

    final bool isPrinted = await Printing.layoutPdf(
      format:
          const PdfPageFormat(5.0 * PdfPageFormat.cm, 2.5 * PdfPageFormat.cm),
      onLayout: (PdfPageFormat format) async => doc.save(),
    );

    Map<String, dynamic> items = {};
    _localDB.items.forEach((e) {
      items[e.itemId!] = e.toMap();
    });

    if (isPrinted) {
      for (var e in newIds) {
        items[e]["status"] = "printed";
      }
    } else {
      for (var e in newIds) {
        items.remove(e);
      }
    }

    await _addNewLocation(
      locations: items,
      uid: itemIdUid,
      updateField: "item_id",
    );
  }

  @override
  Future<void> printContainerIds(List<String> newIds) async {
    final pw.Document doc = pw.Document();
    final barcode = Barcode.code128();

    for (String id in newIds) {
      final svgBarcode = barcode.toSvg(id,
          width: 15 * PdfPageFormat.cm, height: 10 * PdfPageFormat.cm);

      doc.addPage(
        pw.Page(
          orientation: pw.PageOrientation.landscape,
          pageFormat: const PdfPageFormat(
              10.0 * PdfPageFormat.cm, 15.0 * PdfPageFormat.cm),
          build: (pw.Context context) {
            return pw.Center(
              child: pw.SvgImage(
                svg: svgBarcode,
                width: 14.0 * PdfPageFormat.cm,
                height: 9.0 * PdfPageFormat.cm,
              ),
            );
          },
        ),
      );
    }

    final bool isPrinted = await Printing.layoutPdf(
      format:
          const PdfPageFormat(10.0 * PdfPageFormat.cm, 15.0 * PdfPageFormat.cm),
      onLayout: (PdfPageFormat format) async => doc.save(),
    );

    Map<String, dynamic> containers = {};
    _localDB.containers.forEach((e) {
      containers[e.containerId!] = e.toMap();
    });

    if (isPrinted) {
      for (var e in newIds) {
        containers[e]["status"] = "printed";
      }
    } else {
      for (var e in newIds) {
        containers.remove(e);
      }
    }

    await _addNewLocation(
      locations: containers,
      uid: containerIdUid,
      updateField: "container_id",
    );
  }
}
