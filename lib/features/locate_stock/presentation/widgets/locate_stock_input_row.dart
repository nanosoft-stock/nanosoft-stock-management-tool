import 'package:flutter/material.dart';
import 'package:stock_management_tool/components/custom_container.dart';
import 'package:stock_management_tool/components/custom_dropdown_input_field.dart';
import 'package:stock_management_tool/constants/constants.dart';

class LocateStockInputRow extends StatelessWidget {
  const LocateStockInputRow({
    super.key,
    required this.index,
    required this.locatedItems,
    required this.showRemoveButton,
    required this.removeOnTap,
    required this.onSearchBySelected,
    required this.onIdSelected,
  });

  final List searchableIds = const [
    "Item Id",
    "Container Id",
    "Warehouse Location Id",
    "Custom Search",
  ];

  final List ids = const ["1", "2", "3", "4", "5"];

  final int index;
  final List locatedItems;
  final bool showRemoveButton;
  final Function() removeOnTap;
  final Function(String) onSearchBySelected;
  final Function(String) onIdSelected;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: showRemoveButton
                    ? GestureDetector(
                        onTap: removeOnTap,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(7),
                            boxShadow: kBoxShadowList,
                          ),
                          child: const SizedBox(
                            width: 30,
                            height: 30,
                            child: Icon(
                              Icons.close_rounded,
                              size: 26,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(
                        width: 30,
                        height: 30,
                      ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: CustomDropdownInputField(
                  text: "Search By",
                  controller: TextEditingController(text: locatedItems[index]["search by"]),
                  items: searchableIds,
                  onSelected: (value) {
                    if (searchableIds.contains(value) || value == "") onSearchBySelected(value);
                  },
                ),
              ),
              if (locatedItems[index]["search by"] != "")
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: CustomDropdownInputField(
                    text: locatedItems[index]["search by"],
                    controller: TextEditingController(text: ""),
                    items: ids,
                    onSelected: (value) {
                      if (ids.contains(value)) onIdSelected(value);
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
