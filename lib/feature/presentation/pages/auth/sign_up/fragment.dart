import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';
import 'package:flutter_andomie/widgets.dart';

import '../../../../../index.dart';

class AuthSignUpFragment extends StatefulWidget {
  final AuthSignInHandler onSignIn;
  final AuthSignUpHandler onSignUp;

  const AuthSignUpFragment({
    Key? key,
    required this.onSignIn,
    required this.onSignUp,
  }) : super(key: key);

  @override
  State<AuthSignUpFragment> createState() => _AuthSignUpFragmentState();
}

class _AuthSignUpFragmentState extends State<AuthSignUpFragment> {
  late EmailEditingController email;
  late PhoneEditingController phone;
  late PasswordEditingController password;

  @override
  void initState() {
    email = EmailEditingController();
    phone = PhoneEditingController();
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
            text: "Create a new account",
            textAlign: TextAlign.start,
            textColor: Colors.black,
            fontWeight: FontWeight.bold,
            textSize: 24,
            marginVertical: 24,
          ),
          EmailField(
            hint: "Enter your email",
            controller: email,
          ),
          PhoneField(
            controller: phone,
            textCode: "+880",
            hintCode: "+880",
            hintNumber: "Enter phone number",
          ),
          PasswordField(
            hint: "Enter your password",
            controller: password,
            margin: EdgeInsets.zero,
          ),
          CreateAccountTextView(
            width: double.infinity,
            textAlign: TextAlign.end,
            padding: const EdgeInsets.all(8),
            text: "Already have an account! ",
            buttonText: "Sign in",
            buttonTextColor: AppColors.primary,
            onPressed: () => widget.onSignIn(UserEntity(
              email: email.text,
              password: password.text,
              phone: phone.number.numberWithCode,
            )),
          ),
          Button(
            margin: const EdgeInsets.symmetric(vertical: 24),
            text: "Register",
            borderRadius: 12,
            primary: AppColors.primary,
            onExecute: () => widget.onSignUp.call(UserEntity(
              email: email.text,
              password: password.text,
              phone: phone.number.numberWithCode,
            )),
          ),
        ],
      ),
    );
  }
}
