import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'index.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: kIsWeb
        ? const FirebaseOptions(
            apiKey: "AIzaSyBmB2nrR8fHhMlWWCMtDJfYsHPY-s0HOa8",
            authDomain: "appeler-7dbb2.firebaseapp.com",
            projectId: "appeler-7dbb2",
            storageBucket: "appeler-7dbb2.appspot.com",
            messagingSenderId: "926347959879",
            appId: "1:926347959879:web:8f71cce0c2f22919b6db62",
          )
        : null,
  );
  await diInit();
  FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: false);

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
