import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_management_tool/services/add_new_stock_provider.dart';

class CustomCheckbox extends StatelessWidget {
  const CustomCheckbox({
    super.key,
    required this.text,
    required this.locked,
  });

  final String text;
  final bool locked;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Provider.of<AddNewStockProvider>(context, listen: false)
            .changeLockableDataSubField(
          field: text,
          subField: "locked",
          value: !locked,
        );
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Material(
            elevation: 7,
            child: Container(
              width: 23.0,
              height: 23.0,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Center(
                child: Container(
                  width: 21.0,
                  height: 21.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Container(
                      width: 15,
                      height: 15,
                      decoration: BoxDecoration(
                        color: locked ? Colors.purple : Colors.white,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
