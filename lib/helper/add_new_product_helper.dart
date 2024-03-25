import 'package:stock_management_tool/constants/constants.dart';
import 'package:stock_management_tool/helper/datatype_converter_helper.dart';
import 'package:stock_management_tool/models/all_predefined_data.dart';

class AddNewProductHelper {
  static Map toJson({required String category, required Map data}) {
    Map convertedData = {};
    if (kIsDesktop) {
      for (var e in AllPredefinedData.data[category]["fields"]
          .where((element) => (element["isWithSKU"] == true && element["field"] != "category"))
          .toList()) {
        convertedData[e["field"]] = {
          DatatypeConverterHelper.convert(datatype: e["datatype"]): data[e["field"]],
        };
      }
    } else {
      data.removeWhere((key, value) => key == "category");
      convertedData = data;
    }

    return convertedData;
  }
}
