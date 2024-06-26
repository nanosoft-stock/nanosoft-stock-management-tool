import 'package:stock_management_tool/core/constants/constants.dart';
import 'package:stock_management_tool/core/helper/case_helper.dart';
import 'package:stock_management_tool/core/helper/datatype_converter_helper.dart';
import 'package:stock_management_tool/core/services/injection_container.dart';
import 'package:stock_management_tool/objectbox.dart';

class AddNewProductHelper {
  static Map<String, dynamic> toJson({required Map data}) {
    final objectbox = sl.get<ObjectBox>();

    Map<String, dynamic> convertedData = {};
    String category = data["category"];

    List fields = objectbox
        .getInputFields()
        .where((element) =>
            element.category!.toLowerCase() == category.toLowerCase())
        .where((ele) => ele.inSku == true)
        .map((e) => e.toJson())
        .toList();

    if (!kIsLinux) {
      for (var e in fields) {
        convertedData[e["field"]] =
            CaseHelper.convert(e["value_case"], data[e["field"]] ?? "").trim();
      }
    } else {
      for (var e in fields) {
        convertedData[e["field"]] = {
          DatatypeConverterHelper.convert(datatype: e["datatype"]):
              CaseHelper.convert(e["value_case"], data[e["field"]] ?? "")
                  .trim(),
        };
      }
    }

    return convertedData;
  }
}
