import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:stock_management_tool/core/constants/constants.dart';
import 'package:stock_management_tool/core/helper/case_helper.dart';
import 'package:stock_management_tool/core/helper/datatype_converter_helper.dart';
import 'package:stock_management_tool/core/services/injection_container.dart';
import 'package:stock_management_tool/objectbox.dart';

class AddNewStockHelper {
  static Map<String, dynamic> toJson({required Map data}) {
    final objectbox = sl.get<ObjectBox>();

    Map<String, dynamic> convertedData = {};
    String category = data["category"];

    List fields = objectbox
        .getInputFields()
        .where((element) =>
            element.category!.toLowerCase() == category.toLowerCase())
        .map((e) => e.toJson())
        .toList();

    if (!kIsLinux) {
      for (var e in fields) {
        if (e["field"] == "date") {
          convertedData[e["field"]] =
              Timestamp.now(); // FieldValue.serverTimestamp();
        } else if (e["field"] == "user") {
          convertedData[e["field"]] =
              CaseHelper.convert(e["value_case"], userName).trim();
        } else {
          convertedData[e["field"]] =
              CaseHelper.convert(e["value_case"], data[e["field"]] ?? "")
                  .trim();
        }
      }
    } else {
      for (var e in fields) {
        if (e["field"] == "date") {
          convertedData[e["field"]] = {
            DatatypeConverterHelper.convert(datatype: e["datatype"]):
                "${DateFormat('yyyy-MM-ddTHH:mm:ss.SSSSSSS').format(DateTime.now())}Z",
          };
        } else if (e["field"] == "user") {
          convertedData[e["field"]] = {
            DatatypeConverterHelper.convert(datatype: e["datatype"]):
                CaseHelper.convert(e["value_case"], userName).trim(),
          };
        } else {
          convertedData[e["field"]] = {
            DatatypeConverterHelper.convert(datatype: e["datatype"]):
                CaseHelper.convert(e["value_case"], data[e["field"]] ?? "")
                    .trim(),
          };
        }
      }
    }

    return convertedData;
  }
}
