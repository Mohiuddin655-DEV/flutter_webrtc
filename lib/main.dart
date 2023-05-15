import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'index.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await diInit();
  runApp(const Application());
}

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppInfo.name,
      theme: ThemeData(
        primarySwatch: AppColors.primarySwatch,
      ),
      initialRoute: SplashActivity.route,
      onGenerateRoute: AppRouter.I.generate,
    );
  }
}
