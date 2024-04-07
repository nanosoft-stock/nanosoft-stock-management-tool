import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_management_tool/components/custom_container.dart';
import 'package:stock_management_tool/constants/constants.dart';
import 'package:stock_management_tool/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:stock_management_tool/features/auth/presentation/views/login_view.dart';
import 'package:stock_management_tool/features/auth/presentation/views/sign_up_view.dart';
import 'package:stock_management_tool/features/auth/presentation/widgets/custom_segmented_button.dart';
import 'package:stock_management_tool/injection_container.dart';

class AuthenticationView extends StatelessWidget {
  AuthenticationView({super.key});

  final AuthBloc _authBloc = sl.get<AuthBloc>();

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  Widget _buildBody() {
    return BlocConsumer<AuthBloc, AuthState>(
      bloc: _authBloc,
      listenWhen: (prev, next) => next is AuthActionState,
      buildWhen: (prev, next) => next is! AuthActionState,
      listener: (context, state) {},
      builder: (BuildContext context, AuthState state) {
        switch (state.runtimeType) {
          case const (LoginState):
            return _authStateWidget(true);

          case const (SignUpState):
            return _authStateWidget(false);

          default:
            return Container();
        }
      },
    );
  }

  Widget _authStateWidget(bool isLogin) {
    return Container(
      decoration: BoxDecoration(
        color: kPrimaryBackgroundColor,
        borderRadius: kBorderRadius,
      ),
      child: Center(
        child: SizedBox(
          width: 350.0,
          child: _authContainer(isLogin),
        ),
      ),
    );
  }

  Widget _authContainer(bool isLogin) {
    return CustomContainer(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 8.0),
              child: SizedBox(
                width: 250,
                child: CustomSegmentedButton(
                  isLogin: isLogin,
                  onSelectionChanged: (value) {
                    if (value.first) {
                      _authBloc.add(LoginSelectedEvent());
                    } else {
                      _authBloc.add(SignUpSelectedEvent());
                    }
                  },
                ),
                // child: _buildSegmentedButton(isLogin),
              ),
            ),
            isLogin ? LoginView(bloc: _authBloc) : SignUpView(bloc: _authBloc),
          ],
        ),
      ),
    );
  }
}
