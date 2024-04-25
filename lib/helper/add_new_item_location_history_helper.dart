import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:stock_management_tool/constants/constants.dart';
import 'package:stock_management_tool/helper/datatype_converter_helper.dart';

class AddNewItemLocationHistoryHelper {
  static Map toJson({required Map data}) {
    Map convertedData = {};

    List fields = [
      "date",
      "items",
      "movement method",
      "container id",
      "warehouse location",
      "staff",
    ];

    if (!kIsLinux) {
      for (var field in fields) {
        if (field == "date") {
          convertedData[field] = FieldValue.serverTimestamp();
        } else if (field == "staff") {
          convertedData[field] = userName;
        } else {
          convertedData[field] = data[field];
        }
      }
    } else {
      for (var field in fields) {
        if (field == "date") {
          convertedData[field] = {
            DatatypeConverterHelper.convert(datatype: "timestamp"):
                "${DateFormat('yyyy-MM-ddTHH:mm:ss.SSSSSSS').format(DateTime.now())}Z",
          };
        } else if (field == "items") {
          convertedData["items"] = {
            DatatypeConverterHelper.convert(datatype: "array"): {
              "values": data["items"]
                  .map((e) => {
                        DatatypeConverterHelper.convert(datatype: "string"): e,
                      })
                  .toList(),
            },
          };
        } else {
          convertedData[field] = {
            DatatypeConverterHelper.convert(datatype: "string"):
                field != "staff" ? data[field] : userName,
          };
        }
      }
    }

    return convertedData;
  }
}
