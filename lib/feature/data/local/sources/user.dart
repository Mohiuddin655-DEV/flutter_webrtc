import 'package:flutter_andomie/core.dart';

class LocalUserDataSource extends LocalDataSourceImpl<UserEntity> {
  LocalUserDataSource({
    super.path = "users",
    required super.db,
  });

  @override
  UserEntity build(source) => UserEntity.from(source);
}
