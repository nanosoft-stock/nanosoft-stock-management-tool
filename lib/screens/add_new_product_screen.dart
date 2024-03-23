import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stock_management_tool/components/custom_dropdown_menu.dart';
import 'package:stock_management_tool/models/all_predefined_data.dart';
import 'package:stock_management_tool/utility/string_casting_extension.dart';

class AddNewProductScreen extends StatefulWidget {
  const AddNewProductScreen({super.key});

  @override
  State<AddNewProductScreen> createState() => _AddNewProductScreenState();
}

class _AddNewProductScreenState extends State<AddNewProductScreen> {
  final TextEditingController controller = TextEditingController();

  Widget displayFields() {
    var data = AllPredefinedData.data[controller.text];
    List fields = data["fields"]
        .where((element) => element["isWithSKU"] == true)
        .toList();
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: fields.length,
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
                    fields[index]['field'].toString().toTitleCase(),
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
                  child: CustomDropDownMenu(
                    controller: TextEditingController(),
                    items: fields[index]['items'] ?? [],
                    onSelected: () {},
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

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
                  child: CustomDropDownMenu(
                    controller: controller,
                    items: AllPredefinedData.data["categories"],
                    onSelected: () {
                      setState(() {});
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        if (AllPredefinedData.data["categories"].contains(controller.text))
          displayFields()
      ],
    );
  }
}
