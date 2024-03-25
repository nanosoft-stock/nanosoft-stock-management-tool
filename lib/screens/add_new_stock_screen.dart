import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_management_tool/components/custom_dropdown_and_checkbox_input_field.dart';
import 'package:stock_management_tool/components/custom_elevated_button.dart';
import 'package:stock_management_tool/components/custom_text_and_checkbox_input_field.dart';
import 'package:stock_management_tool/constants/constants.dart';
import 'package:stock_management_tool/helper/add_new_stock_helper.dart';
import 'package:stock_management_tool/helper/string_casting_extension.dart';
import 'package:stock_management_tool/models/all_predefined_data.dart';
import 'package:stock_management_tool/providers/add_new_stock_provider.dart';
import 'package:stock_management_tool/services/firebase_rest_api.dart';

class AddNewStockScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AddNewStockProvider>(
      builder: (BuildContext context, provider, Widget? child) {
        List fields =
            (AllPredefinedData.data["categories"].contains(provider.currentCategory?.toLowerCase())
                ? AllPredefinedData.data[provider.currentCategory?.toLowerCase()]["fields"]
                    .where((element) => !(["date", "user", "archived"].contains(element["field"])))
                    .toList()
                : [
                    {
                      "field": "category",
                      "datatype": "string",
                      "lockable": true,
                      "isWithSKU": false,
                      "order": 2,
                    },
                  ]);
        return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            int n = ((constraints.maxWidth - 135) / 390.5).floor();
            double pad = ((constraints.maxWidth - 135) % 390.5) / 2;
            return constraints.maxWidth > 525
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
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: n > 0 ? n : 1,
                                  mainAxisSpacing: 0,
                                  crossAxisSpacing: 0,
                                  mainAxisExtent: 95,
                                ),
                                itemBuilder: (context, index) {
                                  List items;
                                  if (fields[index]['field'] == "category") {
                                    items = AllPredefinedData.data["categories"]
                                        .map(
                                          (e) => e.toString().toTitleCase(),
                                        )
                                        .toList();
                                  } else if (fields[index]['field'] == "sku") {
                                    items = AllPredefinedData
                                            .data[provider.currentCategory?.toLowerCase()]
                                                ["products"]
                                            .map((e) => e["sku"])
                                            .toList() ??
                                        [];
                                  } else {
                                    items = fields[index]['items'] ?? [];
                                  }

                                  if (!provider.hasBuilt) {
                                    if (fields[index]['field'] == "category") {
                                      if (!provider.cacheData.containsKey("category")) {
                                        provider.changeCacheData(
                                          field: "category",
                                          data: {
                                            "controller": TextEditingController(),
                                            "locked": false
                                          },
                                        );
                                      }
                                    } else {
                                      provider.changeCacheData(
                                        field: fields[index]['field'],
                                        data: {
                                          "controller": TextEditingController(),
                                          "locked": false
                                        },
                                      );
                                    }
                                  }
                                  if (index == fields.length - 1) {
                                    provider.hasBuilt = true;
                                  }

                                  return Padding(
                                    padding: const EdgeInsets.all(7.5),
                                    child: ![
                                      "item id",
                                      "serial number",
                                      "dispatch info",
                                      "supplier info",
                                      "location",
                                      "comments"
                                    ].contains(fields[index]['field'])
                                        ? CustomDropdownAndCheckboxInputField(
                                            text: fields[index]['field'],
                                            controller: provider.cacheData[fields[index]['field']]
                                                ['controller'],
                                            items: items,
                                            lockable: fields[index]['lockable'],
                                            alignLockable: !fields[index]['lockable'],
                                            locked: provider.cacheData[fields[index]['field']]
                                                ["locked"],
                                            onSelected: () {
                                              if (fields[index]['field'] == "category" &&
                                                  provider.currentCategory !=
                                                      provider.cacheData["category"]['controller']
                                                          .text) {
                                                provider.hasBuilt = false;
                                                provider.currentCategory = provider
                                                    .cacheData["category"]['controller'].text;
                                                provider.cacheData
                                                    .removeWhere((key, value) => key != "category");
                                                provider.refresh();
                                              }
                                              try {
                                                if (fields[index]['field'] == "sku") {
                                                  var productDesc = AllPredefinedData
                                                      .data[provider.currentCategory?.toLowerCase()]
                                                          ["products"]
                                                      .where((e) =>
                                                          e['sku'] ==
                                                          provider
                                                              .cacheData["sku"]["controller"].text)
                                                      .toList()[0];
                                                  for (var key in productDesc.keys) {
                                                    provider.cacheData[key]["controller"].text =
                                                        productDesc[key].toString();
                                                  }
                                                }
                                              } catch (e) {}
                                            },
                                          )
                                        : CustomTextAndCheckboxInputField(
                                            text: fields[index]['field'],
                                            controller: provider.cacheData[fields[index]['field']]
                                                ['controller'],
                                            lockable: fields[index]['lockable'],
                                            alignLockable: !fields[index]['lockable'],
                                            locked: fields[index]['lockable']
                                                ? provider.cacheData[fields[index]['field']]
                                                    ["locked"]
                                                : false,
                                          ),
                                  );
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
                              width: 390.5,
                              child: CustomElevatedButton(
                                text: "Add New Stock",
                                onPressed: () async {
                                  if (provider.cacheData["category"]['controller'].text != "") {
                                    Map storedData = {};

                                    for (var key in provider.cacheData.keys) {
                                      storedData[key] =
                                          provider.cacheData[key]["controller"].text.toString();
                                    }

                                    await FirebaseRestApi().createDocument(
                                      path: "stock_data",
                                      json: AddNewStockHelper.toJson(
                                        data: storedData,
                                      ),
                                    );

                                    for (var key in provider.cacheData.keys) {
                                      if (!provider.cacheData[key]["locked"]) {
                                        provider.cacheData[key]["controller"].text = "";
                                      }
                                    }

                                    if (!provider.cacheData["category"]["locked"]) {
                                      provider.deleteCacheData();
                                    }
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
