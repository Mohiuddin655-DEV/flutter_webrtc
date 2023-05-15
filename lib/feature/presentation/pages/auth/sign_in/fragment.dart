import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';
import 'package:flutter_andomie/widgets.dart';

import '../../../../../index.dart';

class AuthSignInFragment extends StatefulWidget {
  final AuthSignInHandler onSignIn;
  final AuthForgotHandler onForgetPassword;
  final AuthCreateHandler onCreateAccount;

  const AuthSignInFragment({
    Key? key,
    required this.onSignIn,
    required this.onForgetPassword,
    required this.onCreateAccount,
  }) : super(key: key);

  @override
  State<AuthSignInFragment> createState() => _AuthSignInFragmentState();
}

class _AuthSignInFragmentState extends State<AuthSignInFragment> {
  late EmailEditingController email;
  late PasswordEditingController password;

  @override
  void initState() {
    email = EmailEditingController();
    password = PasswordEditingController();
    super.initState();
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LinearLayout(
        orientation: Axis.vertical,
        paddingVertical: 24,
        paddingHorizontal: 32,
        children: [
          const TextView(
            width: double.infinity,
            text: "Sign in",
            textAlign: TextAlign.start,
            textColor: Colors.black,
            fontWeight: FontWeight.bold,
            textSize: 24,
            marginVertical: 24,
          ),
          EmailField(
            controller: email,
          ),
          PasswordField(
            hint: "Enter your password",
            controller: password,
            margin: EdgeInsets.zero,
          ),
          AppTextButton(
            width: double.infinity,
            textAlign: TextAlign.end,
            padding: const EdgeInsets.all(8),
            text: "Forget password?",
            onPressed: () => widget.onForgetPassword.call(UserEntity(
              email: email.text,
              password: password.text,
            )),
          ),
          CreateAccountTextView(
            width: double.infinity,
            textAlign: TextAlign.end,
            padding: const EdgeInsets.all(8),
            text: "Don't have an account? ",
            buttonText: "Sign up!",
            buttonTextColor: AppColors.primary,
            onPressed: () => widget.onCreateAccount.call(UserEntity(
              email: email.text,
              password: password.text,
            )),
          ),
          Button(
            margin: const EdgeInsets.symmetric(vertical: 24),
            text: "Login",
            borderRadius: 12,
            primary: AppColors.primary,
            onExecute: () => widget.onSignIn.call(UserEntity(
              email: email.text,
              password: password.text,
            )),
          ),
        ],
      ),
    );
  }
}
