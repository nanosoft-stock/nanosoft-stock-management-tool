import 'package:flutter/material.dart';
import 'package:stock_management_tool/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:stock_management_tool/features/auth/presentation/widgets/custom_text_form_field.dart';
import 'package:stock_management_tool/features/auth/presentation/widgets/custom_submit_button.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key, required this.bloc});

  final AuthBloc bloc;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> signInUser({required BuildContext context}) async {
    bloc.add(LoginButtonClickedEvent(
      email: emailController.text.toLowerCase().trim(),
      password: passwordController.text.trim(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomTextFormField(
            controller: emailController,
            label: 'Email',
            type: TextInputType.emailAddress,
            action: TextInputAction.next,
          ),
          CustomTextFormField(
            controller: passwordController,
            label: 'Password',
            type: TextInputType.visiblePassword,
            action: TextInputAction.done,
            obscureText: true,
            onFieldSubmitted: (_) async {
              await signInUser(context: context);
            },
          ),
          CustomSubmitButton(
            text: 'Login',
            onPressed: () async {
              await signInUser(context: context);
            },
          ),
        ],
      ),
    );
  }
}
