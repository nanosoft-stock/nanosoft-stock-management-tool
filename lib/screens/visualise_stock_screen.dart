import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_management_tool/components/custom_data_grid.dart';
import 'package:stock_management_tool/constants/constants.dart';
import 'package:stock_management_tool/providers/export_stock_provider.dart';

class VisualiseStockScreen extends StatelessWidget {
  const VisualiseStockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ExportStockProvider>(
      builder: (BuildContext context, provider, Widget? child) {
        return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(52, 80, 52, 40),
              child: Container(
                decoration: BoxDecoration(
                  color: kSecondaryBackgroundColor,
                  borderRadius: kBorderRadius,
                  boxShadow: kBoxShadowList,
                ),
                child: const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: CustomDataGrid(),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
