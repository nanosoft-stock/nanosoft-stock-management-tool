import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_management_tool/providers/export_stock_provider.dart';

enum Sort {
  asc,
  desc,
  none,
}

class FieldSortWidget extends StatelessWidget {
  FieldSortWidget({
    super.key,
    required this.field,
    this.sort = Sort.none,
  });

  final String field;
  Sort sort;

  void switchSort(BuildContext context) {
    sort = Sort.values[(Sort.values.indexOf(sort) + 1) % Sort.values.length];
    Provider.of<ExportStockProvider>(context, listen: false).sortStock(
      field: field,
      sort: sort,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        switchSort(context);
      },
      child: Builder(
        builder: (BuildContext context) {
          if (sort == Sort.none) {
            return const Icon(Icons.remove_rounded);
          } else if (sort == Sort.asc) {
            return const Icon(Icons.arrow_downward_rounded);
          } else {
            return const Icon(Icons.arrow_upward_rounded);
          }
        },
      ),
    );
  }
}
