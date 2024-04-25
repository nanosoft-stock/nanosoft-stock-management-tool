import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multiple_search_selection/multiple_search_selection.dart';
import 'package:stock_management_tool/components/custom_container.dart';
import 'package:stock_management_tool/constants/constants.dart';

class CustomMultipleSearchSelection extends StatelessWidget {
  const CustomMultipleSearchSelection({
    super.key,
    required this.multipleSearchController,
    required this.title,
    required this.initialPickedItems,
    required this.items,
  });

  final MultipleSearchController multipleSearchController;
  final String title;
  final List initialPickedItems;
  final List items;

  @override
  Widget build(BuildContext context) {
    return MultipleSearchSelection(
      controller: multipleSearchController,
      title: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          title,
          style: kLabelTextStyle,
        ),
      ),
      sortPickedItems: true,
      sortShowedItems: true,
      itemsVisibility: ShowedItemsVisibility.alwaysOn,
      initialPickedItems: initialPickedItems,
      items: items,
      maximumShowItemsHeight: 30 * 5,
      showedItemsScrollController: ScrollController(),
      searchField: TextField(
        autofocus: true,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          filled: true,
          fillColor: kInputFieldFillColor,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: kBorderRadius,
          ),
        ),
      ),
      fieldToCheck: (id) {
        return id;
      },
      pickedItemsScrollController: ScrollController(),
      pickedItemsContainerBuilder: (widgets) {
        return Row(
          children: [
            Expanded(
              child: Container(
                height: 100,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: kTertiaryBackgroundColor,
                  borderRadius: kBorderRadius,
                  boxShadow: kBoxShadowList,
                ),
                child: SingleChildScrollView(
                  child: Wrap(children: widgets),
                ),
              ),
            ),
          ],
        );
      },
      pickedItemBuilder: (value) {
        return Padding(
          padding: const EdgeInsets.all(5.0),
          child: CustomContainer(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                value,
                style: GoogleFonts.lato(
                  textStyle: const TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        );
      },
      showedItemsBoxDecoration: BoxDecoration(
        color: kTertiaryBackgroundColor,
        // borderRadius: kBorderRadius,
        boxShadow: kBoxShadowList,
      ),
      itemBuilder: (value, index) {
        return Container(
          height: 30,
          decoration: BoxDecoration(
            color: index % 2 == 0 ? Colors.white : Colors.grey.withOpacity(0.2),
            border: null,
            // borderRadius: kBorderRadius,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 5.0, 5.0, 5.0),
            child: Text(
              value,
              style: GoogleFonts.lato(
                textStyle: const TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
