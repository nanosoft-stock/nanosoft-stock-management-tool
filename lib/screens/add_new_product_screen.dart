import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stock_management_tool/components/custom_dropdown_menu.dart';
import 'package:stock_management_tool/models/category_model.dart';
import 'package:stock_management_tool/services/firebase_rest_api.dart';
import 'package:stock_management_tool/utility/string_casting_extension.dart';

class AddNewProductScreen extends StatefulWidget {
  const AddNewProductScreen({super.key});

  @override
  State<AddNewProductScreen> createState() => _AddNewProductScreenState();
}

class _AddNewProductScreenState extends State<AddNewProductScreen> {
  final TextEditingController controller = TextEditingController();

  Widget displayFields() {
    return FutureBuilder(
      future: CategoryModel().fetchFields(value: controller.text.toLowerCase()),
      builder: (context, snapshot1) {
        if (snapshot1.hasData) {
          var data = snapshot1.data!;
          data.removeWhere((element) => element["isWithSKU"] == false);
          data.removeWhere((element) => element["field"] == "sku");
          return ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: snapshot1.data!.length,
            itemBuilder: (context, index) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 100,
                        child: Text(
                          snapshot1.data![index]['field']
                              .toString()
                              .toTitleCase(),
                          style: const TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        child: FutureBuilder(
                          future: FirebaseRestApi().filterQuery(
                            path: "category_list/${CategoryModel.doc}",
                            from: [
                              {
                                "collectionId": "drop_down_values",
                                "allDescendants": false
                              }
                            ],
                            where: {
                              "fieldFilter": {
                                "field": {
                                  "fieldPath": "field",
                                },
                                "op": "EQUAL",
                                "value": {
                                  "stringValue": snapshot1.data![index]['field']
                                      .toString(),
                                }
                              }
                            },
                          ),
                          builder: (context, snapshot2) {
                            if (snapshot2.hasData) {
                              return FutureBuilder(
                                future: FirebaseRestApi().getFields(
                                    path:
                                        "category_list/${CategoryModel.doc}/drop_down_values/${snapshot2.data!.first}"),
                                builder: (context, snapshot3) {
                                  if (snapshot3.hasData) {
                                    return CustomDropDownMenu(
                                      controller: TextEditingController(),
                                      items: snapshot3.data!["values"]
                                              ["arrayValue"]["values"]
                                          .map((e) => e["stringValue"])
                                          .toList(),
                                      onSelected: () {
                                        // setState(() {});
                                      },
                                    );
                                  } else {
                                    return Container();
                                  }
                                },
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        } else {
          return Container();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
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
                    child: CustomDropDownMenu(
                      controller: controller,
                      items: CategoryModel.items,
                      onSelected: () {
                        setState(() {});
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (CategoryModel.items.contains(controller.text)) displayFields()
        ],
      ),
    );
  }
}
