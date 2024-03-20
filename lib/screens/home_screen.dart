import 'package:flutter/material.dart';
import 'package:flutter_side_menu/flutter_side_menu.dart';
import 'package:provider/provider.dart';
import 'package:stock_management_tool/services/firebase_provider.dart';
import 'package:stock_management_tool/services/nav_item_model.dart';

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

  @override
  void initState() {
    super.initState();
    currentNavItem = addNewStockNavItem;
    addNewStockNavItem.isSelected = true;
  }

  SideMenuItemDataTile createMenuItem({required NavItemModel navItemModel}) {
    return SideMenuItemDataTile(
      isSelected: navItemModel.isSelected,
      icon: Icon(navItemModel.icon),
      title: navItemModel.title,
      onTap: () {
        if (currentNavItem != null || currentNavItem != navItemModel) {
          currentNavItem?.isSelected = false;
          currentNavItem = navItemModel;
          navItemModel.isSelected = true;
          setState(() {});
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SideMenu(
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
                      child: Image.asset('images/nanosoft_logo.png'),
                    )
                  : Container(),
              items: [
                const SideMenuItemDataDivider(divider: Divider()),
                createMenuItem(navItemModel: addNewStockNavItem),
                createMenuItem(navItemModel: addNewProductNavItem),
                const SideMenuItemDataDivider(divider: Divider()),
                createMenuItem(navItemModel: exportStockNavItem),
                const SideMenuItemDataDivider(divider: Divider()),
                createMenuItem(navItemModel: modifyStockNavItem),
                createMenuItem(navItemModel: modifyProductNavItem),
                const SideMenuItemDataDivider(divider: Divider()),
                createMenuItem(navItemModel: archiveStockNavItem),
                createMenuItem(navItemModel: archiveProductNavItem),
              ],
              footer: Padding(
                padding: data.isOpen
                    ? const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0)
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
          child: Container(),
        ),
      ],
    );
  }
}
