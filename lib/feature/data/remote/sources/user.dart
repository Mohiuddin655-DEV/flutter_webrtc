import 'package:flutter_andomie/core.dart';

class UserDataSource extends FireStoreDataSourceImpl<UserEntity> {
  UserDataSource({
    super.path = "users",
  });

  @override
  UserEntity build(source) => UserEntity.from(source);
}
