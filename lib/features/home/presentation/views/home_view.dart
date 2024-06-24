import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_side_menu/flutter_side_menu.dart';
import 'package:stock_management_tool/core/components/custom_container.dart';
import 'package:stock_management_tool/core/constants/constants.dart';
import 'package:stock_management_tool/core/services/injection_container.dart';
import 'package:stock_management_tool/features/home/presentation/bloc/home_bloc.dart';
import 'package:stock_management_tool/features/home/presentation/models/nav_item_and_view_model.dart';
import 'package:stock_management_tool/features/home/presentation/widgets/custom_side_menu.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  final HomeBloc _homeBloc = sl.get<HomeBloc>();
  final SideMenuController _controller = SideMenuController();

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  Widget _buildBody() {
    return BlocConsumer<HomeBloc, HomeState>(
      bloc: _homeBloc,
      listenWhen: (prev, next) => next is HomeActionState,
      buildWhen: (prev, next) => next is! HomeActionState,
      listener: (context, state) {},
      builder: (context, state) {
        return _blocBuilder(context, state);
      },
    );
  }

  Widget _blocBuilder(BuildContext context, HomeState state) {
    switch (state.runtimeType) {
      case const (ErrorState):
        return _buildErrorStateWidget();

      case const (ViewLoadedState):
        String view = state.view!;
        return _buildLoadedStateWidget(view);

      default:
        return Container();
    }
  }

  Widget _buildErrorStateWidget() {
    return const Center(
      child: Text('Error'),
    );
  }

  Widget _buildLoadedStateWidget(String view) {
    return Row(
      children: [
        CustomSideMenu(
          view: view,
          homeBloc: _homeBloc,
          controller: _controller,
        ),
        _buildView(view),
      ],
    );
  }

  Widget _buildView(String view) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(color: kPrimaryBackgroundColor),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: CustomContainer(
                child: IconButton(
                  onPressed: () {
                    _controller.toggle();
                  },
                  hoverColor: Colors.transparent,
                  icon: const Icon(Icons.menu_outlined),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: FocusScope(
                child: NavItemAndViewModel.allNavItemAndView[view].view,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
