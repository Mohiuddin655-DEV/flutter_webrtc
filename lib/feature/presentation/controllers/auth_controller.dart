import 'package:flutter_andomie/core.dart';

class AppAuthController extends AuthController {

  AppAuthController({
    required super.handler,
    required super.userHandler,
  });

  Future<bool> signIn(UserEntity data) async {
    await signInByEmail(data);
    return true;
  }

  Future<bool> signUp(UserEntity data) async {
    await signUpByEmail(data);
    return true;
  }

  Future<bool> forgot(UserEntity data) async {
    return true;
  }
}
