import 'package:flutter/material.dart';
import 'package:flutter_side_menu/flutter_side_menu.dart';
import 'package:provider/provider.dart';
import 'package:stock_management_tool/constants/constants.dart';
import 'package:stock_management_tool/features/add_new_product/presentation/bloc/add_new_product_bloc.dart';
import 'package:stock_management_tool/features/add_new_product/presentation/views/add_new_product_screen.dart';
import 'package:stock_management_tool/features/add_new_stock/presentation/views/add_new_stock_screen.dart';
import 'package:stock_management_tool/injection_container.dart';
import 'package:stock_management_tool/models/nav_item_model.dart';
import 'package:stock_management_tool/providers/add_new_product_provider.dart';
import 'package:stock_management_tool/providers/add_new_stock_provider.dart';
import 'package:stock_management_tool/providers/firebase_provider.dart';
import 'package:stock_management_tool/providers/side_menu_provider.dart';
import 'package:stock_management_tool/screens/archive_product_screen.dart';
import 'package:stock_management_tool/screens/archive_stock_screen.dart';
import 'package:stock_management_tool/screens/export_stock_screen.dart';
import 'package:stock_management_tool/screens/modify_product_screen.dart';
import 'package:stock_management_tool/screens/modify_stock_screen.dart';
import 'package:stock_management_tool/screens/visualise_stock_screen.dart';
import 'package:stock_management_tool/services/auth.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

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

  final NavItemModel visualiseStockNavItem = NavItemModel(
    index: 2,
    title: 'Visualise Stock',
    icon: Icons.table_chart_outlined,
  );

  final NavItemModel exportStockNavItem = NavItemModel(
    index: 3,
    title: 'Export Stock',
    icon: Icons.file_download_outlined,
  );

  final NavItemModel modifyStockNavItem = NavItemModel(
    index: 4,
    title: 'Modify Stock',
    icon: Icons.edit_note_outlined,
  );

  final NavItemModel modifyProductNavItem = NavItemModel(
    index: 5,
    title: 'Modify Product',
    icon: Icons.edit_note_outlined,
  );

  final NavItemModel archiveStockNavItem = NavItemModel(
    index: 6,
    title: 'Archive Stock',
    icon: Icons.archive_outlined,
  );

  final NavItemModel archiveProductNavItem = NavItemModel(
    index: 7,
    title: 'Archive Product',
    icon: Icons.archive_outlined,
  );

  final NavItemModel accountItemMenuNavItem = NavItemModel(
    index: 8,
    title: 'Log out',
    icon: Icons.logout,
  );

  final allHomeScreens = [
    AddNewStockScreen(),
    AddNewProductScreen(),
    const VisualiseStockScreen(),
    const ExportStockScreen(),
    const ModifyStockScreen(),
    const ModifyProductScreen(),
    const ArchiveStockScreen(),
    const ArchiveProductScreen(),
  ];

  SideMenuItemDataTile createMenuItem({
    required BuildContext context,
    required SideMenuProvider provider,
    required NavItemModel navItemModel,
  }) {
    return SideMenuItemDataTile(
      isSelected: navItemModel.isSelected,
      icon: Icon(navItemModel.icon),
      title: navItemModel.title,
      titleStyle: kLabelTextStyle,
      selectedTitleStyle: kButtonTextStyle,
      borderRadius: kBorderRadius,
      onTap: () async {
        if (provider.currentNavItemModel != navItemModel) {
          if (provider.currentNavItemModel == addNewStockNavItem) {
            Provider.of<AddNewStockProvider>(context, listen: false)
                .deleteCacheData();
          } else if (provider.currentNavItemModel == addNewProductNavItem) {
            sl.get<AddNewProductBloc>().close();
            Provider.of<AddNewProductProvider>(context, listen: false)
                .deleteCacheData();
          }

          provider.currentNavItemModel!.isSelected = false;
          navItemModel.isSelected = true;
          provider.changeCurrentNavItemModel(navItemModel: navItemModel);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SideMenuProvider>(
      builder:
          (BuildContext context, SideMenuProvider provider, Widget? child) {
        if (!provider.hasBuilt) {
          // print(provider.currentNavItemModel?.title);
          provider.currentNavItemModel ??= addNewStockNavItem;
          provider.hasBuilt = true;
        }

        // print(AllPredefinedData.data);

        return Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: kSecondaryBackgroundColor,
                borderRadius: kBorderRadius,
                boxShadow: kBoxShadowList,
              ),
              child: SideMenu(
                controller: provider.sideMenuController,
                priority: SideMenuPriority.mode,
                hasResizer: false,
                hasResizerToggle: false,
                mode: SideMenuMode.auto,
                builder: (data) {
                  return SideMenuData(
                    header: data.isOpen
                        ? Padding(
                            padding: const EdgeInsets.fromLTRB(
                                20.0, 20.0, 100.0, 10.0),
                            child: SizedBox(
                              height: 36,
                              child: Image.asset('images/nanosoft_logo.png'),
                            ),
                          )
                        : const SizedBox.shrink(),
                    items: [
                      if (data.isOpen)
                        const SideMenuItemDataDivider(divider: Divider()),
                      createMenuItem(
                        context: context,
                        provider: provider,
                        navItemModel: addNewStockNavItem,
                      ),
                      createMenuItem(
                        context: context,
                        provider: provider,
                        navItemModel: addNewProductNavItem,
                      ),
                      const SideMenuItemDataDivider(divider: Divider()),
                      createMenuItem(
                        context: context,
                        provider: provider,
                        navItemModel: visualiseStockNavItem,
                      ),
                      createMenuItem(
                        context: context,
                        provider: provider,
                        navItemModel: exportStockNavItem,
                      ),
                      const SideMenuItemDataDivider(divider: Divider()),
                      createMenuItem(
                        context: context,
                        provider: provider,
                        navItemModel: modifyStockNavItem,
                      ),
                      createMenuItem(
                        context: context,
                        provider: provider,
                        navItemModel: modifyProductNavItem,
                      ),
                      const SideMenuItemDataDivider(divider: Divider()),
                      createMenuItem(
                        context: context,
                        provider: provider,
                        navItemModel: archiveStockNavItem,
                      ),
                      createMenuItem(
                        context: context,
                        provider: provider,
                        navItemModel: archiveProductNavItem,
                      ),
                    ],
                    footer: Padding(
                      padding: data.isOpen
                          ? const EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 10.0)
                          : const EdgeInsets.symmetric(vertical: 15.0),
                      child: data.currentWidth == data.maxWidth
                          ? ListTile(
                              leading: Icon(accountItemMenuNavItem.icon),
                              title: Text(
                                accountItemMenuNavItem.title,
                                style: kLabelTextStyle,
                              ),
                              onTap: () async {
                                await Auth().signOutUser(
                                  onSuccess: () {
                                    userName = "";
                                    Provider.of<FirebaseProvider>(context,
                                            listen: false)
                                        .changeIsUserLoggedIn(
                                            isUserLoggedIn: false);
                                  },
                                );
                              },
                            )
                          : GestureDetector(
                              onTap: () async {
                                await Auth().signOutUser(
                                  onSuccess: () {
                                    userName = "";
                                    Provider.of<FirebaseProvider>(context,
                                            listen: false)
                                        .changeIsUserLoggedIn(
                                            isUserLoggedIn: false);
                                  },
                                );
                              },
                              child: Icon(accountItemMenuNavItem.icon),
                            ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(color: kPrimaryBackgroundColor),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: kSecondaryBackgroundColor,
                          borderRadius: kBorderRadius,
                          boxShadow: kBoxShadowList,
                        ),
                        child: IconButton(
                          onPressed: () {
                            provider.toggleSideMenu();
                          },
                          hoverColor: Colors.transparent,
                          icon: const Icon(Icons.menu_outlined),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child:
                          allHomeScreens[provider.currentNavItemModel!.index],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
