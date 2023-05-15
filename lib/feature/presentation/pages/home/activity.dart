import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../index.dart';

class HomeActivity extends StatelessWidget {
  static const String route = "home";
  static const String title = "Home";

  const HomeActivity({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => locator<HomeController>()),
        ],
        child: BlocConsumer<HomeController, AuthResponse>(
          listener: (context, state) {
            if (!state.isLoggedIn) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AuthActivity.route,
                (route) => false,
              );
            }
          },
          builder: (context, state) {
            return const HomeBody(
              type: HomeBodyType.initial,
            );
          },
        ),
      ),
    );
  }
}
