import 'package:stock_management_tool/core/helper/string_casting_extension.dart';

class CaseHelper {
  static String convert(String valueCase, String value) {
    switch (valueCase.toLowerCase()) {
      case "upper":
        {
          return value.toUpperCase();
        }
      case "title":
        {
          return value.toTitleCase();
        }
      case "lower":
        {
          return value.toLowerCase();
        }
      default:
        {
          return value;
        }
    }
  }
}
