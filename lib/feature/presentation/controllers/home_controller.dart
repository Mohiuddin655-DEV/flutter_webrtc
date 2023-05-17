import 'package:flutter_andomie/core.dart';

import '../../../index.dart';
import '../../domain/handlers/meeting.dart';

class HomeController extends AuthController {
  final MeetingHandler roomHandler;

  HomeController({
    required super.handler,
    required super.userHandler,
    required this.roomHandler,
  });

  String? generateRoom() {
    final newDoc = roomHandler.root.doc();
    newDoc.set(<String, dynamic>{});
    var roomId = newDoc.id;
    return roomId;
  }
}
