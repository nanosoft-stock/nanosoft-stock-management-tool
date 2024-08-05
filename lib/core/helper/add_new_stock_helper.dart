import 'package:stock_management_tool/core/helper/case_helper.dart';
import 'package:stock_management_tool/core/local_database/local_database.dart';
import 'package:stock_management_tool/core/services/injection_container.dart';

class AddNewStockHelper {
  static Map<String, dynamic> toMap({required Map data}) {
    final LocalDatabase localDB = sl.get<LocalDatabase>();

    Map<String, dynamic> convertedData = {};
    String category = data["category"];

    List fields = localDB.categoryFields
        .where((element) =>
            element.category!.toLowerCase() == category.toLowerCase() &&
            element.field != "date")
        .map((e) => e.toMap())
        .toList();

    for (var field in fields) {
      String fieldName =
          field["field"].toString().toLowerCase().replaceAll(" ", "_");

      if (fieldName == "sku") {
        convertedData["sku_uuid"] = null;
      } else if (fieldName == "user") {
        convertedData["user_uuid"] = CaseHelper.convert(
            field["value_case"], localDB.user.userUUID ?? "");
      } else {
        convertedData[fieldName] =
            CaseHelper.convert(field["value_case"], data[field["field"]] ?? "")
                .trim();
      }
    }

    return convertedData;
  }
}
