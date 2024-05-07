import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multiple_search_selection/createable/create_options.dart';
import 'package:multiple_search_selection/multiple_search_selection.dart';
import 'package:stock_management_tool/constants/constants.dart';

class CustomMultipleSearchSelection extends StatelessWidget {
  const CustomMultipleSearchSelection({
    super.key,
    required this.multipleSearchController,
    required this.title,
    required this.initialPickedItems,
    required this.items,
    required this.onIdEntered,
  });

  final MultipleSearchController multipleSearchController;
  final String title;
  final List initialPickedItems;
  final List items;
  final Function(String) onIdEntered;

  @override
  Widget build(BuildContext context) {
    return MultipleSearchSelection.creatable(
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
      pickedItemsScrollPhysics: const BouncingScrollPhysics(),
      pickedItemsScrollController: ScrollController(),
      showShowedItemsScrollbar: false,
      showedItemsScrollPhysics: const BouncingScrollPhysics(),
      showedItemsScrollController: ScrollController(),
      searchField: TextField(
        autofocus: true,
        textInputAction: TextInputAction.continueAction,
        decoration: InputDecoration(
          filled: true,
          fillColor: kInputFieldFillColor,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: kBorderRadius,
          ),
        ),
        onSubmitted: (value) {
          if (value.trim() != "") {
            onIdEntered(value);
            multipleSearchController.clearSearchField();
          }
        },
      ),
      fieldToCheck: (id) {
        return id;
      },
      createOptions: CreateOptions(
        create: (String id) => id,
        pickCreated: true,
        createBuilder: (String value) {
          return Container(
            height: 30,
            decoration: BoxDecoration(
              color: kFailBackgroundColor,
              border: null,
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
      ),
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
          child: Container(
            decoration: BoxDecoration(
              color: items.contains(value)
                  ? kSecondaryBackgroundColor
                  : kFailBackgroundColor,
              borderRadius: kBorderRadius,
              boxShadow: kBoxShadowList,
            ),
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
        boxShadow: kBoxShadowList,
      ),
      itemBuilder: (value, index) {
        return Container(
          height: 30,
          decoration: BoxDecoration(
            color: items.contains(value)
                ? (index % 2 == 0 ? Colors.white : Colors.grey.withOpacity(0.2))
                : kFailBackgroundColor,
            border: null,
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
