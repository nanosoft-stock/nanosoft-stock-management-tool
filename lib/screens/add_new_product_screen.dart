import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stock_management_tool/components/custom_dropdown_menu.dart';
import 'package:stock_management_tool/models/category_model.dart';
import 'package:stock_management_tool/utility/string_casting_extension.dart';

class AddNewProductScreen extends StatefulWidget {
  AddNewProductScreen({super.key});

  @override
  State<AddNewProductScreen> createState() => _AddNewProductScreenState();
}

class _AddNewProductScreenState extends State<AddNewProductScreen> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Widget displayFields() {
    print("Displaying Fields");
    // List<Widget> fieldWidgets = [];
    // CategoryModel().fetchFields(value: controller.text.toLowerCase());
    // print(CategoryModel.fields.length);
    // for (var element in CategoryModel.fields) {
    //   fieldWidgets.add(SingleChildScrollView(
    //     scrollDirection: Axis.horizontal,
    //     child: Row(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         Padding(
    //           padding: EdgeInsets.all(8.0),
    //           child: SizedBox(
    //             width: 100,
    //             child: Text(
    //               element['field'].toString().toTitleCase(),
    //               style: TextStyle(
    //                 fontSize: 14.0,
    //                 fontWeight: FontWeight.bold,
    //               ),
    //             ),
    //           ),
    //         ),
    //         Padding(
    //           padding: const EdgeInsets.all(8.0),
    //           child: SizedBox(
    //             child: CustomDropDownMenu().createDropdownMenu(
    //               controller: controller,
    //               items: CategoryModel.items,
    //               onSelected: () {
    //                 setState(() {});
    //               },
    //             ),
    //           ),
    //         ),
    //       ],
    //     ),
    //   ));
    // }
    // print(fieldWidgets.length);
    // return Column(
    //   children: fieldWidgets,
    // );
    return FutureBuilder(
      future: CategoryModel().fetchFields(value: controller.text.toLowerCase()),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print("snapshot: ${snapshot.data}");
          return ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 100,
                        child: Text(
                          snapshot.data![index]['field']
                              .toString()
                              .toTitleCase(),
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
                        child: CustomDropDownMenu().createDropdownMenu(
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
                    child: CustomDropDownMenu().createDropdownMenu(
                        controller: controller,
                        items: CategoryModel.items,
                        onSelected: () {
                          setState(() {});
                        }),
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
