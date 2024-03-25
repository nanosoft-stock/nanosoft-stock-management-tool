import 'package:stock_management_tool/helper/datatype_converter_helper.dart';
import 'package:stock_management_tool/models/all_predefined_data.dart';

class AddNewProductHelper {
  static Map toJson({required String category, required Map data}) {
    Map convertedData = {};
    for (var e in AllPredefinedData.data[category]["fields"]
        .where((element) => (element["isWithSKU"] == true))
        .toList()) {
      convertedData[e["field"]] = {
        DatatypeConverterHelper.convert(datatype: e["datatype"]):
            data[e["field"]],
      };
    }

    return convertedData;
  }
}
