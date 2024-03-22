import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stock_management_tool/components/custom_dropdown_menu.dart';
import 'package:stock_management_tool/models/category_model.dart';

class AddNewProductScreen extends StatelessWidget {
  AddNewProductScreen({super.key});

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 100,
                  child: Text(
                    "Category",
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  child: CustomDropDownMenu()
                      .createDropdownMenu(items: CategoryModel.items),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
