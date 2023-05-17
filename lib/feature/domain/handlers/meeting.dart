import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_andomie/core.dart';

import '../../../index.dart';

class MeetingHandler extends DataHandlerImpl<Meeting> {
  MeetingHandler({
    required super.repository,
  });

  CollectionReference get root {
    return FirebaseFirestore.instance.collection(ApiKeys.meetings);
  }

  DocumentReference getMeetingReference(String id) {
    return root.doc(id);
  }

  Stream<Contributor> liveContributor(String meetingId, String id) {
    final controller = StreamController<Contributor>();
    try {
      root.doc(meetingId).snapshots().listen((event) {
        if (event.exists || event.data() != null) {
          var value = event.data();
          if (value is Map<String, dynamic>) {
            var data = value[id];
            if (data is Map<String, dynamic>) {
              var con = Contributor.from(data);
              controller.add(con);
            }
          }
        } else {
          controller.addError("Data not found!");
        }
      });
    } catch (_) {
      controller.addError(_);
    }
    return controller.stream;
  }

  void setStatus({
    required String id,
    required bool isMute,
    required bool isRiseHand,
    required bool isCameraOn,
    required bool isFrontCamera,
  }) {
    var ref = root.doc(id);
    ref.get().then((value) {
      final data = value.data()!;
      if (data is Map<String, dynamic>) {
        data[AuthHelper.uid] = {
          'isMute': isMute,
          'handUp': isRiseHand,
          'isCameraOn': isCameraOn,
          'isFrontCamera': isFrontCamera,
        };
      }
      ref.set(data);
    });
  }

  void changeStatus({
    required String id,
    required bool isMute,
    required bool isRiseHand,
    required bool isCameraOn,
    required bool isFrontCamera,
  }) {
    var ref = root.doc(id);
    ref.get().then((value) {
      final data = value.data()!;
      if (data is Map<String, dynamic>) {
        data[AuthHelper.uid] = {
          'isMute': isMute,
          'handUp': isRiseHand,
          'isCameraOn': isCameraOn,
          'isFrontCamera': isFrontCamera,
        };
        ref.update(data);
      }
    });
  }

  void removeStatus(String id) {
    var ref = root.doc(id);
    ref.get().then((value) {
      final data = value.data()!;
      if (data is Map<String, dynamic>) {
        data.remove(AuthHelper.uid);
        if (data.isEmpty) {
          ref.delete();
        } else {
          ref.set(data);
        }
      }
    });
  }
}
