import 'package:flutter/material.dart';
import 'package:stock_management_tool/components/custom_dropdown_input_field.dart';
import 'package:stock_management_tool/components/custom_elevated_button.dart';
import 'package:stock_management_tool/components/custom_text_input_field.dart';
import 'package:stock_management_tool/constants/constants.dart';
import 'package:stock_management_tool/helper/add_new_product_helper.dart';
import 'package:stock_management_tool/helper/string_casting_extension.dart';
import 'package:stock_management_tool/models/all_predefined_data.dart';
import 'package:stock_management_tool/services/firebase_rest_api.dart';

Map<String, dynamic> storedData = {};

class AddNewProductScreen extends StatefulWidget {
  const AddNewProductScreen({super.key});

  @override
  State<AddNewProductScreen> createState() => _AddNewProductScreenState();
}

class _AddNewProductScreenState extends State<AddNewProductScreen> {
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController skuController = TextEditingController();

  List<TextEditingController> allOtherControllers = [];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        int n = ((constraints.maxWidth - 135) / 338).floor();
        double pad = ((constraints.maxWidth - 135) % 338) / 2;
        return constraints.maxWidth > 475
            ? Padding(
                padding: EdgeInsets.fromLTRB(52 + pad, 20, 52 + pad, 40),
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
                            itemCount: (AllPredefinedData.data["categories"]
                                        .contains(categoryController.text
                                            .toLowerCase())
                                    ? AllPredefinedData.data[categoryController
                                            .text
                                            .toLowerCase()]["fields"]
                                        .where((element) =>
                                            (element["isWithSKU"] == true &&
                                                element["field"] != "sku"))
                                        .toList()
                                        .length
                                    : 0) +
                                2,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: n > 0 ? n : 1,
                              mainAxisSpacing: 0,
                              crossAxisSpacing: 0,
                              mainAxisExtent: 95,
                            ),
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return Padding(
                                  padding: const EdgeInsets.all(7.5),
                                  child: CustomDropdownInputField(
                                    text: "Category",
                                    controller: categoryController,
                                    items: AllPredefinedData.data["categories"]
                                        .map(
                                          (e) => e.toString().toTitleCase(),
                                        )
                                        .toList(),
                                    onSelected: () {
                                      storedData = {};
                                      allOtherControllers = [];
                                      storedData["category"] =
                                          categoryController.text.toLowerCase();
                                      setState(() {});
                                    },
                                  ),
                                );
                              } else if (index == 1) {
                                return Padding(
                                  padding: const EdgeInsets.all(7.5),
                                  child: CustomTextInputField(
                                    text: "SKU",
                                    controller: skuController,
                                  ),
                                );
                              } else {
                                var data = AllPredefinedData.data[
                                    categoryController.text.toLowerCase()];
                                var fields = data["fields"]
                                    .where((element) =>
                                        (element["isWithSKU"] == true &&
                                            element["field"] != "sku"))
                                    .toList();
                                final TextEditingController controller =
                                    TextEditingController();
                                allOtherControllers.add(controller);
                                return Padding(
                                  padding: const EdgeInsets.all(7.5),
                                  child: CustomDropdownInputField(
                                    text: fields[index - 2]['field']
                                        .toString()
                                        .toTitleCase(),
                                    controller: controller,
                                    items: fields[index - 2]['items'] ?? [],
                                    onSelected: () {
                                      storedData[fields[index - 2]['field']
                                          .toString()] = controller.text;
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
                            text: "Add New Product",
                            onPressed: () async {
                              if (categoryController.text != "") {
                                storedData['sku'] = skuController.text;
                                await FirebaseRestApi().createDocument(
                                  path:
                                      "category_list/${AllPredefinedData.data[storedData["category"]]["categoryDoc"]}/product_list",
                                  json: AddNewProductHelper.toJson(
                                    data: storedData,
                                  ),
                                );
                              }

                              storedData = {};
                              categoryController.text = "";
                              skuController.text = "";
                              for (var e in allOtherControllers) {
                                e.text = "";
                              }
                              allOtherControllers = [];
                              setState(() {});
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : const SizedBox.shrink();
      },
    );
  }
}
