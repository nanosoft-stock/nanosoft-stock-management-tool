import 'package:flutter/material.dart';
import 'package:stock_management_tool/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:stock_management_tool/features/auth/presentation/widgets/custom_submit_button.dart';
import 'package:stock_management_tool/features/auth/presentation/widgets/custom_text_form_field.dart';

class SignUpView extends StatelessWidget {
  SignUpView({super.key, required this.bloc});

  final AuthBloc bloc;

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> signUpUser({required BuildContext context}) async {
    bloc.add(SignUpButtonClickedEvent(
      username: usernameController.text.toLowerCase().trim(),
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
            controller: usernameController,
            label: 'Username',
            type: TextInputType.text,
            action: TextInputAction.next,
          ),
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
              await signUpUser(context: context);
            },
          ),
          CustomSubmitButton(
            text: 'Sign Up',
            onPressed: () async {
              await signUpUser(context: context);
            },
          ),
        ],
      ),
    );
  }
}
