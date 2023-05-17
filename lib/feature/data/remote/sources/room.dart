import 'package:flutter_andomie/core.dart';

import '../../../../index.dart';

class MeetingDataSource extends FireStoreDataSourceImpl<Meeting> {
  MeetingDataSource({
    super.path = ApiKeys.meetings,
  });

  @override
  Meeting build(source) {
    return Meeting.from(source);
  }
}
