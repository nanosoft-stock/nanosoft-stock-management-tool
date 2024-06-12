import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:stock_management_tool/core/constants/constants.dart';
import 'package:stock_management_tool/core/helper/datatype_converter_helper.dart';
import 'package:stock_management_tool/injection_container.dart';
import 'package:stock_management_tool/objectbox.dart';

class AddNewStockHelper {
  static Map toJson({required Map data}) {
    Map convertedData = {};

    final objectbox = sl.get<ObjectBox>();

    String category = data["category"].toString().toLowerCase();

    List fields = objectbox
        .getInputFields()
        .where((element) => element.category == category)
        .map((e) => e.toJson())
        .toList();

    if (kIsLinux) {
      for (var e in fields) {
        if (e["field"] == "date") {
          convertedData[e["field"]] = {
            DatatypeConverterHelper.convert(datatype: e["datatype"]):
                "${DateFormat('yyyy-MM-ddTHH:mm:ss.SSSSSSS').format(DateTime.now())}Z",
          };
        } else if (e["field"] == "staff") {
          convertedData[e["field"]] = {
            DatatypeConverterHelper.convert(datatype: e["datatype"]): userName,
          };
        } else if (e["field"] == "archived") {
          convertedData[e["field"]] = {
            DatatypeConverterHelper.convert(datatype: e["datatype"]): false,
          };
        } else {
          convertedData[e["field"]] = {
            DatatypeConverterHelper.convert(datatype: e["datatype"]):
                data[e["field"]] ?? "",
          };
        }
      }
    } else {
      for (var e in fields) {
        if (e["field"] == "date") {
          convertedData[e["field"]] =
              Timestamp.now(); // FieldValue.serverTimestamp();
        } else if (e["field"] == "staff") {
          convertedData[e["field"]] = userName;
        } else if (e["field"] == "archived") {
          convertedData[e["field"]] = false;
        } else {
          convertedData[e["field"]] = data[e["field"]] ?? "";
        }
      }
    }

    return convertedData;
  }
}
