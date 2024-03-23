import 'package:flutter/material.dart';
import 'package:stock_management_tool/components/custom_dropdown_input_field.dart';
import 'package:stock_management_tool/components/custom_text_input_field.dart';
import 'package:stock_management_tool/models/all_predefined_data.dart';
import 'package:stock_management_tool/utility/string_casting_extension.dart';

class AddNewProductScreen extends StatefulWidget {
  const AddNewProductScreen({super.key});

  @override
  State<AddNewProductScreen> createState() => _AddNewProductScreenState();
}

class _AddNewProductScreenState extends State<AddNewProductScreen> {
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController skuController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(60, 20, 60, 50),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white38,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return GridView.builder(
                  itemCount: (AllPredefinedData.data["categories"]
                              .contains(categoryController.text.toLowerCase())
                          ? AllPredefinedData
                              .data[categoryController.text.toLowerCase()]
                                  ["fields"]
                              .where((element) =>
                                  (element["isWithSKU"] == true &&
                                      element["field"] != "sku"))
                              .toList()
                              .length
                          : 0) +
                      2,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: (constraints.maxWidth / 340).floor() > 0
                        ? (constraints.maxWidth / 340).floor()
                        : 1,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15,
                    mainAxisExtent: 80,
                  ),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return CustomDropdownInputField(
                        text: "Category",
                        controller: categoryController,
                        items: AllPredefinedData.data["categories"]
                            .map(
                              (e) => e.toString().toTitleCase(),
                            )
                            .toList(),
                        onSelected: () {
                          setState(() {});
                        },
                      );
                    } else if (index == 1) {
                      return CustomTextInputField(
                        text: "SKU",
                        controller: skuController,
                      );
                    } else {
                      var data = AllPredefinedData
                          .data[categoryController.text.toLowerCase()];
                      var fields = data["fields"]
                          .where((element) => (element["isWithSKU"] == true &&
                              element["field"] != "sku"))
                          .toList();
                      return CustomDropdownInputField(
                        text:
                            fields[index - 2]['field'].toString().toTitleCase(),
                        controller: TextEditingController(),
                        items: fields[index - 2]['items'] ?? [],
                        onSelected: () {},
                      );
                    }
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
