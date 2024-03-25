import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_management_tool/components/custom_dropdown_input_field.dart';
import 'package:stock_management_tool/components/custom_elevated_button.dart';
import 'package:stock_management_tool/components/custom_text_input_field.dart';
import 'package:stock_management_tool/constants/constants.dart';
import 'package:stock_management_tool/helper/add_new_product_helper.dart';
import 'package:stock_management_tool/helper/string_casting_extension.dart';
import 'package:stock_management_tool/models/all_predefined_data.dart';
import 'package:stock_management_tool/providers/add_new_product_provider.dart';
import 'package:stock_management_tool/services/firebase_rest_api.dart';

class AddNewProductScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AddNewProductProvider>(
      builder: (BuildContext context, provider, Widget? child) {
        List fields = (AllPredefinedData.data["categories"]
                .contains(provider.currentCategory?.toLowerCase())
            ? AllPredefinedData.data[provider.currentCategory?.toLowerCase()]
                    ["fields"]
                .where((element) => element["isWithSKU"] == true)
                .toList()
            : [
                {
                  "field": "category",
                  "datatype": "string",
                  "isWithSKU": true,
                },
                {
                  "field": "sku",
                  "datatype": "string",
                  "isWithSKU": true,
                },
              ]);
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
                                itemCount: fields.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: n > 0 ? n : 1,
                                  mainAxisSpacing: 0,
                                  crossAxisSpacing: 0,
                                  mainAxisExtent: 95,
                                ),
                                itemBuilder: (context, index) {
                                  if (index == 0) {
                                    if (!provider.hasBuilt) {
                                      if (!provider.cacheData
                                          .containsKey("category")) {
                                        provider.changeCacheData(
                                          field: "category",
                                          data: {
                                            "controller":
                                                TextEditingController()
                                          },
                                        );
                                      }
                                    }
                                    if (index == fields.length - 1) {
                                      provider.hasBuilt = true;
                                    }
                                    return Padding(
                                      padding: const EdgeInsets.all(7.5),
                                      child: CustomDropdownInputField(
                                        text: "category",
                                        controller:
                                            provider.cacheData["category"]
                                                ['controller'],
                                        items: AllPredefinedData
                                            .data["categories"]
                                            .map(
                                              (e) => e.toString().toTitleCase(),
                                            )
                                            .toList(),
                                        onSelected: () {
                                          if (provider.currentCategory !=
                                              provider
                                                  .cacheData["category"]
                                                      ['controller']
                                                  .text) {
                                            provider.hasBuilt = false;
                                            provider.currentCategory = provider
                                                .cacheData["category"]
                                                    ['controller']
                                                .text;
                                            provider.cacheData.removeWhere(
                                              (key, value) => ![
                                                "category",
                                                "sku"
                                              ].contains(key),
                                            );
                                            provider.refresh();
                                          }
                                        },
                                      ),
                                    );
                                  } else if (index == 1) {
                                    if (!provider.hasBuilt) {
                                      provider.changeCacheData(
                                        field: fields[index]['field'],
                                        data: {
                                          "controller": TextEditingController(),
                                        },
                                      );
                                    }
                                    if (index == fields.length - 1) {
                                      provider.hasBuilt = true;
                                    }
                                    return Padding(
                                      padding: const EdgeInsets.all(7.5),
                                      child: CustomTextInputField(
                                        text: "sku",
                                        controller: provider.cacheData["sku"]
                                            ['controller'],
                                      ),
                                    );
                                  } else {
                                    if (!provider.hasBuilt) {
                                      provider.changeCacheData(
                                        field: fields[index]['field'],
                                        data: {
                                          "controller": TextEditingController(),
                                        },
                                      );
                                    }
                                    if (index == fields.length - 1) {
                                      provider.hasBuilt = true;
                                    }
                                    return Padding(
                                      padding: const EdgeInsets.all(7.5),
                                      child: CustomDropdownInputField(
                                        text: fields[index]['field'].toString(),
                                        controller: provider.cacheData[
                                                fields[index]['field']]
                                            ['controller'],
                                        items: fields[index]['items'] ?? [],
                                        onSelected: () {},
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
                            padding: const EdgeInsets.symmetric(
                              vertical: 15.0,
                              horizontal: 22.5,
                            ),
                            child: SizedBox(
                              width: 338,
                              child: CustomElevatedButton(
                                text: "Add New Product",
                                onPressed: () async {
                                  if (provider
                                          .cacheData["category"]["controller"]
                                          .text !=
                                      "") {
                                    Map storedData = {};

                                    for (var key in provider.cacheData.keys) {
                                      storedData[key] = provider
                                          .cacheData[key]["controller"].text
                                          .toString();
                                    }

                                    await FirebaseRestApi().createDocument(
                                      path:
                                          "category_list/${AllPredefinedData.data[provider.currentCategory?.toLowerCase()]["categoryDoc"]}/product_list",
                                      json: AddNewProductHelper.toJson(
                                        category: provider.currentCategory!
                                            .toLowerCase(),
                                        data: storedData,
                                      ),
                                    );

                                    provider.deleteCacheData();
                                  }
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
      },
    );
  }
}
