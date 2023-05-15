import 'package:flutter/material.dart';

import 'index.dart';

class AppRouter {
  const AppRouter._();

  static AppRouter get I => const AppRouter._();

  Route<T> generate<T>(RouteSettings settings) {
    final route = settings.name;
    final data = settings.arguments;
    switch (route) {
      case SplashActivity.route:
        return _splash(data);
      case AuthActivity.route:
        return _auth(data);
      case HomeActivity.route:
        return _home(data);
      default:
        return _error(data);
    }
  }

  Route<T> _splash<T>(dynamic data) {
    return MaterialPageRoute(
      builder: (context) => const SplashActivity(),
    );
  }

  Route<T> _auth<T>(dynamic data) {
    return MaterialPageRoute(
      builder: (context) => AuthActivity(
        type: data is AuthFragmentType ? data : null,
      ),
    );
  }

  Route<T> _home<T>(dynamic data) {
    return MaterialPageRoute(
      builder: (context) => const HomeActivity(),
    );
  }

  Route<T> _error<T>(dynamic data) {
    return MaterialPageRoute(
      builder: (context) => const ErrorScreen(),
    );
  }
}

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Error"),
      ),
      body: SafeArea(
        child: Center(
          child: Text(
            "No screen found!",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey.withOpacity(0.5),
            ),
          ),
        ),
      ),
    );
  }
}
