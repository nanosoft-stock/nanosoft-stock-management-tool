import 'package:flutter/material.dart';
import 'package:flutter_side_menu/flutter_side_menu.dart';
import 'package:provider/provider.dart';
import 'package:stock_management_tool/constants/constants.dart';
import 'package:stock_management_tool/models/all_predefined_data.dart';
import 'package:stock_management_tool/models/category_model.dart';
import 'package:stock_management_tool/models/nav_item_model.dart';
import 'package:stock_management_tool/screens/add_new_product_screen.dart';
import 'package:stock_management_tool/screens/add_new_stock_screen.dart';
import 'package:stock_management_tool/screens/archive_product_screen.dart';
import 'package:stock_management_tool/screens/archive_stock_screen.dart';
import 'package:stock_management_tool/screens/export_stock_screen.dart';
import 'package:stock_management_tool/screens/modify_product_screen.dart';
import 'package:stock_management_tool/screens/modify_stock_screen.dart';
import 'package:stock_management_tool/services/firebase_provider.dart';
import 'package:stock_management_tool/services/firestore.dart';
import 'package:stock_management_tool/services/side_menu_provider.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NavItemModel? currentNavItem;

  final NavItemModel addNewStockNavItem = NavItemModel(
    index: 0,
    title: 'Add New Stock',
    icon: Icons.add_box_outlined,
    isSelected: true,
  );

  final NavItemModel addNewProductNavItem = NavItemModel(
    index: 1,
    title: 'Add New Product',
    icon: Icons.add_box_outlined,
  );

  final NavItemModel exportStockNavItem = NavItemModel(
    index: 2,
    title: 'Export Stock',
    icon: Icons.file_download_outlined,
  );

  final NavItemModel modifyStockNavItem = NavItemModel(
    index: 3,
    title: 'Modify Stock',
    icon: Icons.edit_note_outlined,
  );

  final NavItemModel modifyProductNavItem = NavItemModel(
    index: 4,
    title: 'Modify Product',
    icon: Icons.edit_note_outlined,
  );

  final NavItemModel archiveStockNavItem = NavItemModel(
    index: 5,
    title: 'Archive Stock',
    icon: Icons.archive_outlined,
  );

  final NavItemModel archiveProductNavItem = NavItemModel(
    index: 6,
    title: 'Archive Product',
    icon: Icons.archive_outlined,
  );

  final NavItemModel accountItemMenuNavItem = NavItemModel(
    index: 7,
    title: 'Log out',
    icon: Icons.logout,
  );

  final allHomeScreens = [
    const AddNewStockScreen(),
    AddNewProductScreen(),
    const ExportStockScreen(),
    const ModifyStockScreen(),
    const ModifyProductScreen(),
    const ArchiveStockScreen(),
    const ArchiveProductScreen(),
  ];

  @override
  void initState() {
    super.initState();
    currentNavItem = addNewStockNavItem;
    Provider.of<SideMenuProvider>(context, listen: false)
        .changeCurrentNavItemModel(navItemModel: currentNavItem);
    CategoryModel().fetchItems();
  }

  SideMenuItemDataTile createMenuItem({
    required BuildContext context,
    required NavItemModel navItemModel,
  }) {
    return SideMenuItemDataTile(
      isSelected: navItemModel.isSelected,
      icon: Icon(navItemModel.icon),
      title: navItemModel.title,
      onTap: () async {
        if (currentNavItem != navItemModel) {
          currentNavItem?.isSelected = false;
          navItemModel.isSelected = true;
          currentNavItem = navItemModel;
          Provider.of<SideMenuProvider>(context, listen: false)
              .changeCurrentNavItemModel(navItemModel: currentNavItem);
          Provider.of<SideMenuProvider>(context, listen: false).refresh();
          setState(() {});
        }
        if (kIsDesktop) {
          // print(await CategoryModel().fetchItems());
          // print(await FieldsModel(category: 'laptops', categoryDoc: "0g9fGWRSBVG8hzX8Gmvt").fetchItems());
          // print(await DropdownFieldModel(category: 'laptops', categoryDoc: '0g9fGWRSBVG8hzX8Gmvt').fetchItems());
          // print(await FirebaseRestApi().getDocuments(path: "category_list"));
          print(await AllPredefinedData().fetchData());
          // print(await CategoryBasedPredefinedData(category: "laptops")
          //     .fetchData());
          // await FirebaseRestApi().filterQuery(
          //   path: "category_list/${CategoryModel.doc}",
          //   from: [
          //     {
          //       "collectionId": "drop_down_values",
          //       "allDescendants": false
          //     }
          //   ],
          //   where: {
          //     "fieldFilter": {
          //       "field": {
          //         "fieldPath": "field",
          //       },
          //       "op": "EQUAL",
          //       "value": {
          //         "stringValue":
          //             "processor"
          //       }
          //     }
          //   },
          // );
          // var data = await FirebaseRestApi().getFields(
          //     path:
          //         "category_list/0g9fGWRSBVG8hzX8Gmvt/drop_down_values/04tAAgpX4GFvqhGFCp78");
          // var d = DropdownValuesModel(
          //   field: data["field"]["stringValue"],
          //   items: data["values"]["arrayValue"]["values"]
          //       .map((e) => e["stringValue"])
          //       .toList(),
          // );
          // print(d.toString());
          // await FirebaseRestApi().getDocuments(collection: 'category_list');
          // CategoryModel().fetchFields(value: "laptops");
          // await FirebaseRestApi().filterQuery(from: [
          //   {"collectionId": "category_list", "allDescendants": false}
          // ], where: {
          //   "fieldFilter": {
          //     "field": {"fieldPath": "category"},
          //     "op": "EQUAL",
          //     "value": {"stringValue": "laptops"}
          //   }
          // });
          // CategoryModel().fetchFields();
        } else {
          Firestore().getDocuments(collection: 'category_list');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SideMenu(
          controller: SideMenuProvider.sideMenuController,
          priority: SideMenuPriority.sizer,
          hasResizer: true,
          hasResizerToggle: false,
          mode: SideMenuMode.open,
          builder: (data) {
            return SideMenuData(
              header: data.isOpen
                  ? Padding(
                      padding:
                          const EdgeInsets.fromLTRB(20.0, 20.0, 100.0, 10.0),
                      child: SizedBox(
                          height: 36,
                          child: Image.asset('images/nanosoft_logo.png')),
                    )
                  : const SizedBox.shrink(),
              items: [
                if (data.isOpen)
                  const SideMenuItemDataDivider(divider: Divider()),
                createMenuItem(
                    context: context, navItemModel: addNewStockNavItem),
                createMenuItem(
                    context: context, navItemModel: addNewProductNavItem),
                const SideMenuItemDataDivider(divider: Divider()),
                createMenuItem(
                    context: context, navItemModel: exportStockNavItem),
                const SideMenuItemDataDivider(divider: Divider()),
                createMenuItem(
                    context: context, navItemModel: modifyStockNavItem),
                createMenuItem(
                    context: context, navItemModel: modifyProductNavItem),
                const SideMenuItemDataDivider(divider: Divider()),
                createMenuItem(
                    context: context, navItemModel: archiveStockNavItem),
                createMenuItem(
                    context: context, navItemModel: archiveProductNavItem),
              ],
              footer: Padding(
                padding: data.isOpen
                    ? const EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 10.0)
                    : const EdgeInsets.symmetric(vertical: 15.0),
                child: data.currentWidth == data.maxWidth
                    ? ListTile(
                        title: Text(accountItemMenuNavItem.title),
                        leading: Icon(accountItemMenuNavItem.icon),
                        onTap: () {
                          Provider.of<FirebaseProvider>(context, listen: false)
                              .changeIsUserLoggedIn(isUserLoggedIn: false);
                        },
                      )
                    : GestureDetector(
                        onTap: () {
                          Provider.of<FirebaseProvider>(context, listen: false)
                              .changeIsUserLoggedIn(isUserLoggedIn: false);
                        },
                        child: Icon(accountItemMenuNavItem.icon),
                      ),
              ),
            );
          },
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: IconButton(
                  onPressed: () {
                    Provider.of<SideMenuProvider>(context, listen: false)
                        .toggleSideMenu();
                  },
                  icon: const Icon(Icons.menu_outlined),
                ),
              ),
              Expanded(
                child: allHomeScreens[Provider.of<SideMenuProvider>(context)
                    .currentNavItemModel!
                    .index],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
