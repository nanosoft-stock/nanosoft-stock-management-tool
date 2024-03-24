import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_management_tool/components/custom_dropdown_and_checkbox_input_field.dart';
import 'package:stock_management_tool/components/custom_elevated_button.dart';
import 'package:stock_management_tool/components/custom_text_and_checkbox_input_field.dart';
import 'package:stock_management_tool/constants/constants.dart';
import 'package:stock_management_tool/helper/string_casting_extension.dart';
import 'package:stock_management_tool/models/all_predefined_data.dart';
import 'package:stock_management_tool/services/add_new_stock_provider.dart';

Map storedData = {};

class AddNewStockScreen extends StatefulWidget {
  const AddNewStockScreen({super.key});

  @override
  State<AddNewStockScreen> createState() => _AddNewStockScreenState();
}

class _AddNewStockScreenState extends State<AddNewStockScreen> {
  bool hasRun = false;
  final TextEditingController categoryController = TextEditingController();

  Map lockableData = {};

  @override
  Widget build(BuildContext context) {
    List fields = (AllPredefinedData.data["categories"]
            .contains(categoryController.text.toLowerCase())
        ? AllPredefinedData.data[categoryController.text.toLowerCase()]
                ["fields"]
            .where((element) =>
                !(["date", "user", "archived"].contains(element["field"])))
            .toList()
        : [AllPredefinedData.data["categories"]]);

    final provider = context.watch<AddNewStockProvider>();

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(52, 20, 52, 40),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: kSecondaryBackgroundColor,
                    borderRadius: kBorderRadius,
                    boxShadow: kBoxShadowList,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: GridView.builder(
                      shrinkWrap: true,
                      itemCount: fields.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 0,
                        crossAxisSpacing: 0,
                        mainAxisExtent: 95,
                      ),
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          if (!hasRun) {
                            print("$index, ${fields.length} $hasRun");
                            provider.changeLockableData(
                              field: "category",
                              data: {
                                "locked": false,
                              },
                            );
                          }
                          return Padding(
                            padding: const EdgeInsets.all(7.5),
                            child: CustomDropdownAndCheckboxInputField(
                              text: "category",
                              controller: categoryController,
                              items: AllPredefinedData.data["categories"]
                                  .map(
                                    (e) => e.toString().toTitleCase(),
                                  )
                                  .toList(),
                              lockable: true,
                              locked: Provider.of<AddNewStockProvider>(context)
                                  .lockableData["category"]["locked"],
                              onSelected: () {
                                storedData = {};
                                // allOtherControllers = [];
                                lockableData = {};
                                storedData["category"] =
                                    categoryController.text.toLowerCase();
                                setState(() {});
                              },
                            ),
                          );
                        }
                        final TextEditingController controller =
                            TextEditingController();
                        if ([
                          "item id",
                          "serial number",
                          "dispatch info",
                          "location",
                          "comments"
                        ].contains(fields[index]['field'].toString())) {
                          if (index == fields.length - 1) {
                            print("$index, ${fields.length} $hasRun 1");
                            hasRun = true;
                          }
                          return Padding(
                            padding: const EdgeInsets.all(7.5),
                            child: CustomTextAndCheckboxInputField(
                              text: fields[index]['field'].toString(),
                              controller: controller,
                              alignLockable: true,
                            ),
                          );
                        } else {
                          if (!hasRun) {
                            print("$index, ${fields.length} $hasRun");
                            provider.changeLockableData(
                              field: fields[index]['field'],
                              data: {
                                "locked": false,
                              },
                            );
                          }
                          if (index == fields.length - 1) {
                            print("$index, ${fields.length} $hasRun 2");
                            hasRun = true;
                          }
                          return Padding(
                            padding: const EdgeInsets.all(7.5),
                            child: CustomDropdownAndCheckboxInputField(
                              text: fields[index]['field'].toString(),
                              controller: controller,
                              items: fields[index]['items'] ?? [],
                              lockable: true,
                              locked: Provider.of<AddNewStockProvider>(context)
                                      .lockableData[fields[index]['field']]
                                  ["locked"],
                              onSelected: () {
                                storedData[fields[index]['field'].toString()] =
                                    controller.text;
                              },
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Container(
                decoration: BoxDecoration(
                  color: kSecondaryBackgroundColor,
                  borderRadius: kBorderRadius,
                  boxShadow: kBoxShadowList,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: SizedBox(
                    width: 338,
                    child: CustomElevatedButton(
                      text: "Add New Stock",
                      onPressed: () async {
                        if (categoryController.text != "") {
                          // await FirebaseRestApi().createDocument(
                          //   path:
                          //       "category_list/${AllPredefinedData.data[storedData["category"]]["categoryDoc"]}/product_list",
                          //   json: AddNewProductHelper.toJson(
                          //     data: storedData,
                          //   ),
                          // );
                        }
                        print(storedData);

                        storedData = {};
                        categoryController.text = "";
                        // skuController.text = "";
                        // for (var e in allOtherControllers) {
                        //   e.text = "";
                        // }
                        // allOtherControllers = [];
                        // setState(() {});
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
