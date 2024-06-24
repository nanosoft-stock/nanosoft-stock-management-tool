import 'package:stock_management_tool/core/constants/constants.dart';
import 'package:stock_management_tool/core/helper/datatype_converter_helper.dart';

class AddNewFieldHelper {
  static Map<String, dynamic> toJson({required Map data}) {
    Map<String, dynamic> convertedData = {};

    List fields = [
      "field",
      "category",
      "datatype",
      "in_sku",
      "is_background",
      "is_lockable",
      if (data.containsKey("items") &&
          data["items"] != null &&
          data["items"].isNotEmpty)
        "items",
      "name_case",
      "value_case",
      "order",
    ];

    if (!kIsLinux) {
      for (var field in fields) {
        convertedData[field] = data[field] ?? "";
      }
    } else {
      for (var field in fields) {
        if (["in_sku", "is_background", "is_lockable"].contains(field)) {
          convertedData[field] = {
            DatatypeConverterHelper.convert(datatype: "bool"): data[field],
          };
        } else if (field == "order") {
          convertedData[field] = {
            DatatypeConverterHelper.convert(datatype: "number"): data[field],
          };
        } else if (field == "items") {
          convertedData[field] = {
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
                data[field] ?? ""
          };
        }
      }
    }

    return convertedData;
  }
}
