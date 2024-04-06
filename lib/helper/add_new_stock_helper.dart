import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:stock_management_tool/constants/constants.dart';
import 'package:stock_management_tool/helper/datatype_converter_helper.dart';
import 'package:stock_management_tool/models/all_predefined_data.dart';

class AddNewStockHelper {
  static Map toJson({required Map data}) {
    Map convertedData = {};

    String category = data["category"].toString().toLowerCase();
    if (kIsDesktop) {
      for (var e in AllPredefinedData.data[category]["fields"]) {
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
            DatatypeConverterHelper.convert(datatype: e["datatype"]): data[e["field"]],
          };
        }
      }
    } else {
      for (var e in AllPredefinedData.data[category]["fields"]) {
        if (e["field"] == "date") {
          convertedData[e["field"]] = FieldValue.serverTimestamp();
        } else if (e["field"] == "staff") {
          convertedData[e["field"]] = userName;
        } else if (e["field"] == "archived") {
          convertedData[e["field"]] = false;
        } else {
          convertedData[e["field"]] = data[e["field"]];
        }
      }
    }

    return convertedData;
  }
}
