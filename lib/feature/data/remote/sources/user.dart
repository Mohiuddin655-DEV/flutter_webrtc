import 'package:flutter_andomie/core.dart';

import '../../../../index.dart';

class UserDataSource extends FireStoreDataSourceImpl<UserEntity> {
  UserDataSource({
    super.path = ApiKeys.users,
  });

  @override
  UserEntity build(source) => UserEntity.from(source);
}
