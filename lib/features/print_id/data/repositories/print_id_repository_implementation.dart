import 'package:barcode/barcode.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:stock_management_tool/core/local_database/local_database.dart';
import 'package:stock_management_tool/core/services/network_services.dart';
import 'package:stock_management_tool/features/print_id/domain/repositories/print_id_repository.dart';

class PrintIdRepositoryImplementation implements PrintIdRepository {
  PrintIdRepositoryImplementation(this._localDB, this._networkServices);

  final LocalDatabase _localDB;
  final NetworkServices _networkServices;

  @override
  Future<List<String>> getItemIds(String countString) async {
    int? count = int.tryParse(countString);

    if (count != null && count != 0) {
      String lastIdStr = (_localDB.items.toList()
            ..sort((a, b) => b.itemId!.compareTo(a.itemId!)))
          .first
          .itemId!;

      int lastId = int.tryParse(lastIdStr) ?? 0;

      List<String> newIds = [];
      for (int i = 1; i <= count; i++) {
        newIds.add((lastId + i).toString().padLeft(8, "0"));
      }

      await _networkServices.postBatch("items", {
        "data":
            newIds.map((ele) => {"item_id": ele, "status": "chosen"}).toList()
      });

      return newIds;
    }

    return [];
  }

  @override
  Future<List<String>> getContainerIds(String countString) async {
    int? count = int.tryParse(countString);

    if (count != null && count != 0) {
      String lastIdStr = (_localDB.containers.toList()
            ..sort((a, b) => b.containerId!.compareTo(a.containerId!)))
          .first
          .containerId!;

      int lastId = int.tryParse(lastIdStr.substring(2)) ?? 0;

      List<String> newIds = [];
      for (int i = 1; i <= count; i++) {
        newIds.add("ST${(lastId + i).toString().padLeft(7, "0")}");
      }

      await _networkServices.postBatch("containers", {
        "data": newIds
            .map((ele) => {
                  "container_id": ele,
                  "warehouse_location_id": "PSEUDO",
                  "status": "chosen"
                })
            .toList()
      });

      return newIds;
    }

    return [];
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

    if (isPrinted) {
      await _networkServices.patchBatch("items", {
        "data":
            newIds.map((ele) => {"item_id": ele, "status": "printed"}).toList()
      });
    } else {
      await _networkServices.deleteBatch("items", {
        "data": newIds.map((ele) => {"item_id": ele}).toList()
      });
    }
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

    if (isPrinted) {
      await _networkServices.patchBatch("containers", {
        "data": newIds
            .map((ele) => {"container_id": ele, "status": "printed"})
            .toList()
      });
    } else {
      await _networkServices.deleteBatch("containers", {
        "data": newIds.map((ele) => {"container_id": ele}).toList()
      });
    }
  }
}
