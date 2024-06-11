import 'package:flutter/material.dart';
import 'package:flutter_side_menu/flutter_side_menu.dart';
import 'package:stock_management_tool/core/components/custom_container.dart';
import 'package:stock_management_tool/core/constants/constants.dart';
import 'package:stock_management_tool/features/home/presentation/bloc/home_bloc.dart';
import 'package:stock_management_tool/features/home/presentation/models/nav_item_and_view_model.dart';
import 'package:stock_management_tool/features/home/presentation/models/nav_item_model.dart';

class CustomSideMenu extends StatelessWidget {
  const CustomSideMenu({
    super.key,
    required this.view,
    required this.homeBloc,
    required this.controller,
  });

  final String view;
  final HomeBloc homeBloc;
  final SideMenuController controller;

  SideMenuItemDataTile createMenuItem({
    required String view,
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
        NavItemAndViewModel.allNavItemAndView[view]!.navItem.isSelected = false;
        navItemModel.isSelected = true;
        homeBloc.add(ViewSelectedEvent(view: navItemModel.title));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      child: SideMenu(
        controller: controller,
        priority: SideMenuPriority.mode,
        hasResizer: false,
        hasResizerToggle: false,
        mode: SideMenuMode.auto,
        builder: (data) {
          return SideMenuData(
            header: data.isOpen
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 20.0, 100.0, 10.0),
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
                view: view,
                navItemModel: NavItemAndViewModel.allNavItemAndView.values
                    .elementAt(0)
                    .navItem,
              ),
              createMenuItem(
                view: view,
                navItemModel: NavItemAndViewModel.allNavItemAndView.values
                    .elementAt(1)
                    .navItem,
              ),
              createMenuItem(
                view: view,
                navItemModel: NavItemAndViewModel.allNavItemAndView.values
                    .elementAt(2)
                    .navItem,
              ),
              const SideMenuItemDataDivider(divider: Divider()),
              createMenuItem(
                view: view,
                navItemModel: NavItemAndViewModel.allNavItemAndView.values
                    .elementAt(3)
                    .navItem,
              ),
              createMenuItem(
                view: view,
                navItemModel: NavItemAndViewModel.allNavItemAndView.values
                    .elementAt(4)
                    .navItem,
              ),
              const SideMenuItemDataDivider(divider: Divider()),
              createMenuItem(
                view: view,
                navItemModel: NavItemAndViewModel.allNavItemAndView.values
                    .elementAt(5)
                    .navItem,
              ),
              createMenuItem(
                view: view,
                navItemModel: NavItemAndViewModel.allNavItemAndView.values
                    .elementAt(6)
                    .navItem,
              ),
              createMenuItem(
                view: view,
                navItemModel: NavItemAndViewModel.allNavItemAndView.values
                    .elementAt(7)
                    .navItem,
              ),
              const SideMenuItemDataDivider(divider: Divider()),
              createMenuItem(
                view: view,
                navItemModel: NavItemAndViewModel.allNavItemAndView.values
                    .elementAt(8)
                    .navItem,
              ),
            ],
            footer: Padding(
              padding: data.isOpen
                  ? const EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 10.0)
                  : const EdgeInsets.symmetric(vertical: 15.0),
              child: data.currentWidth == data.maxWidth
                  ? ListTile(
                      leading:
                          Icon(NavItemAndViewModel.logOutItemMenuNavItem.icon),
                      title: Text(
                        NavItemAndViewModel.logOutItemMenuNavItem.title,
                        style: kLabelTextStyle,
                      ),
                      onTap: () async {
                        homeBloc.add(SignOutEvent());
                      },
                    )
                  : GestureDetector(
                      onTap: () async {
                        homeBloc.add(SignOutEvent());
                      },
                      child:
                          Icon(NavItemAndViewModel.logOutItemMenuNavItem.icon),
                    ),
            ),
          );
        },
      ),
    );
  }
}
