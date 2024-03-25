import 'package:intl/intl.dart';
import 'package:stock_management_tool/helper/datatype_converter_helper.dart';
import 'package:stock_management_tool/models/all_predefined_data.dart';

class AddNewStockHelper {
  static Map toJson({required Map data}) {
    Map convertedData = {};

    String category = data["category"].toString().toLowerCase();

    for (var e in AllPredefinedData.data[category]["fields"]) {
      if (e["field"] == "date") {
        convertedData[e["field"]] = {
          DatatypeConverterHelper.convert(datatype: e["datatype"]):
              "${DateFormat('yyyy-MM-ddTHH:mm:ss.SSSSSSS').format(DateTime.now())}Z",
        };
      } else if (e["field"] == "user") {
        convertedData[e["field"]] = {
          DatatypeConverterHelper.convert(datatype: e["datatype"]): "iniyan",
        };
      } else if (e["field"] == "archived") {
        convertedData[e["field"]] = {
          DatatypeConverterHelper.convert(datatype: e["datatype"]): false,
        };
      } else {
        convertedData[e["field"]] = {
          DatatypeConverterHelper.convert(datatype: e["datatype"]):
              data[e["field"]],
        };
      }
    }

    return convertedData;
  }
}
