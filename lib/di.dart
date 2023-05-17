import 'package:appeler/feature/data/remote/sources/room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_andomie/core.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'index.dart';

GetIt locator = GetIt.instance;

Future<void> diInit() async {
  final local = await SharedPreferences.getInstance();
  final firebaseAuth = FirebaseAuth.instance;
  final facebookAuth = FacebookAuth.instance;
  final biometricAuth = LocalAuthentication();
  final database = FirebaseFirestore.instance;
  final realtime = FirebaseDatabase.instance;
  locator.registerLazySingleton<SharedPreferences>(() => local);
  locator.registerLazySingleton<FirebaseAuth>(() => firebaseAuth);
  locator.registerLazySingleton<FacebookAuth>(() => facebookAuth);
  locator.registerLazySingleton<LocalAuthentication>(() => biometricAuth);
  locator.registerLazySingleton<FirebaseFirestore>(() => database);
  locator.registerLazySingleton<FirebaseDatabase>(() => realtime);
  _helpers();
  _dataSources();
  _repositories();
  _handlers();
  _controllers();
  await locator.allReady();
}

void _helpers() {}

void _dataSources() {
  locator.registerLazySingleton<AuthDataSource>(() {
    return AuthDataSourceImpl(
      facebookAuth: locator(),
      firebaseAuth: locator(),
      localAuth: locator(),
    );
  });
  locator.registerLazySingleton<LocalDataSource<UserEntity>>(() {
    return LocalUserDataSource(db: locator());
  });
  locator.registerLazySingleton<DataSource<Meeting>>(() {
    return MeetingDataSource();
  });
}

void _repositories() {
  locator.registerLazySingleton<AuthRepository>(() {
    return AuthRepositoryImpl(
      authDataSource: locator.call(),
    );
  });
  locator.registerLazySingleton<DataRepository<UserEntity>>(() {
    return UserRepository(
      remote: UserDataSource(),
    );
  });
  locator.registerLazySingleton<LocalDataRepository<UserEntity>>(() {
    return LocalDataRepositoryImpl<UserEntity>(
      local: locator(),
    );
  });
  locator.registerLazySingleton<DataRepository<Meeting>>(() {
    return DataRepositoryImpl<Meeting>(
      remote: locator(),
    );
  });
}

void _handlers() {
  locator.registerLazySingleton<AuthHandler>(() {
    return AuthHandlerImpl(repository: locator());
  });
  locator.registerLazySingleton<UserHandler>(() {
    return UserHandlerImpl(
      repository: locator(),
      localDataRepository: locator(),
    );
  });
  locator.registerLazySingleton<MeetingHandler>(() {
    return MeetingHandler(
      repository: locator(),
    );
  });
}

void _controllers() {
  locator.registerFactory<AppAuthController>(() {
    return AppAuthController(
      handler: locator(),
      userHandler: locator(),
    );
  });
  locator.registerFactory<HomeController>(() {
    return HomeController(
      handler: locator(),
      userHandler: locator(),
      roomHandler: locator(),
    );
  });
  locator.registerFactory<MeetingController>(() {
    return MeetingController(
      handler: locator(),
    );
  });
}
