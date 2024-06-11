import 'package:stock_management_tool/core/constants/constants.dart';
import 'package:stock_management_tool/core/helper/datatype_converter_helper.dart';
import 'package:stock_management_tool/injection_container.dart';
import 'package:stock_management_tool/objectbox.dart';

class AddNewProductHelper {
  static Map toJson({required String category, required Map data}) {
    Map convertedData = {};

    if (kIsLinux) {
      final objectbox = sl.get<ObjectBox>();

      List fields = objectbox
          .getInputFields()
          .where((element) =>
              element.isWithSKU! && element.category == category.toLowerCase())
          .map((e) => e.toJson())
          .toList();

      for (var e in fields) {
        convertedData[e["field"]] = {
          DatatypeConverterHelper.convert(datatype: e["datatype"]):
              data[e["field"]],
        };
      }
    } else {
      convertedData = data;
    }

    return convertedData;
  }
}
