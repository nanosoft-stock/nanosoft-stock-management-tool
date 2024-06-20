import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:stock_management_tool/core/constants/constants.dart';
import 'package:stock_management_tool/core/helper/case_helper.dart';
import 'package:stock_management_tool/core/helper/datatype_converter_helper.dart';

class AddNewItemLocationHistoryHelper {
  static Map toJson({required Map data}) {
    Map convertedData = {};

    List fields = [
      "date",
      "group_id",
      "items",
      "container_id",
      "warehouse_location_id",
      "move_type",
      "state",
      "user",
    ];

    if (!kIsLinux) {
      for (var field in fields) {
        if (field == "date") {
          convertedData[field] =
              Timestamp.now(); // FieldValue.serverTimestamp();
        } else if (field == "user") {
          convertedData[field] = CaseHelper.convert("title", userName);
        } else {
          convertedData[field] = data[field] ?? "";
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
            DatatypeConverterHelper.convert(datatype: "string"): field != "user"
                ? data[field] ?? ""
                : CaseHelper.convert("title", userName),
          };
        }
      }
    }

    return convertedData;
  }
}
