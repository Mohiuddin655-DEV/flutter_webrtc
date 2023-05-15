import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../index.dart';

typedef AuthCreateHandler = Function(UserEntity data);
typedef AuthForgotHandler = Function(UserEntity data);

typedef AuthSignInHandler = Function(UserEntity data);
typedef AuthSignUpHandler = Function(UserEntity data);

class AuthBody extends StatefulWidget {
  final AuthFragmentType type;

  const AuthBody({
    Key? key,
    required this.type,
  }) : super(key: key);

  @override
  State<AuthBody> createState() => _AuthBodyState();
}

class _AuthBodyState extends State<AuthBody> {
  late AppAuthController controller;

  @override
  void initState() {
    controller = context.read<AppAuthController>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.type) {
      case AuthFragmentType.signIn:
        return AuthSignInFragment(
          onSignIn: controller.signIn,
          onCreateAccount: (data) => Navigator.pushNamed(
            context,
            AuthActivity.route,
            arguments: AuthFragmentType.signUp,
          ),
          onForgetPassword: (data) => Navigator.pushNamed(
            context,
            AuthActivity.route,
            arguments: AuthFragmentType.forgotPassword,
          ),
        );
      case AuthFragmentType.signUp:
        return AuthSignUpFragment(
          onSignUp: controller.signUp,
          onSignIn: (data) => Navigator.pop(context, data),
        );
      case AuthFragmentType.forgotPassword:
        return AuthForgotPasswordFragment(
          onForgot: controller.forgot,
        );
    }
  }
}
