import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_management_tool/components/custom_elevated_button.dart';
import 'package:stock_management_tool/constants/constants.dart';
import 'package:stock_management_tool/helper/export_stock_helper.dart';

class ExportStockScreen extends StatelessWidget {
  const ExportStockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, value, Widget? child) {
        return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(52, 20, 52, 40),
              child: Container(
                decoration: BoxDecoration(
                  color: kSecondaryBackgroundColor,
                  borderRadius: kBorderRadius,
                  boxShadow: kBoxShadowList,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: kSecondaryBackgroundColor,
                        borderRadius: kBorderRadius,
                        boxShadow: kBoxShadowList,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 15.0,
                          horizontal: 22.5,
                        ),
                        child: SizedBox(
                          width: 338,
                          child: CustomElevatedButton(
                            text: "Export Stock",
                            onPressed: () async {
                              List stock = await ExportStockHelper().fetchData();
                              await ExportStockHelper().convertToExcel(stock: stock);
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
