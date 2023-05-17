import 'package:flutter_andomie/core.dart';

class Meeting extends Entity {
  final List<Contributor> contributors;

  Meeting({
    super.id = "",
    super.timeMills,
    this.contributors = const [],
  });

  factory Meeting.from(dynamic source) {
    var data = source is Map<String, dynamic> ? source : {};
    final id = data["id"];
    return Meeting(
      id: id ?? "",
    );
  }

  @override
  Map<String, dynamic> get source {
    return {
      "id": id,
      "time_mills": timeMills,
      "contributors": contributors,
    };
  }
}

class Contributor extends Entity {
  final bool? _cameraOn;
  final bool? _mute;
  final bool? _riseHand;

  bool get isCameraOn => _cameraOn ?? false;

  bool get isMute => _mute ?? false;

  bool get isRiseHand => _riseHand ?? false;

  Contributor({
    super.id = "",
    super.timeMills,
    bool? cameraOn,
    bool? mute,
    bool? riseHand,
  })  : _cameraOn = cameraOn,
        _mute = mute,
        _riseHand = riseHand;

  factory Contributor.from(dynamic source) {
    var data = source is Map<String, dynamic> ? source : {};
    final id = data["id"];
    final timeMills = data["time_mills"];
    final cameraOn = data["isCameraOn"];
    final mute = data["isMute"];
    final riseHand = data["handUp"];
    return Contributor(
      id: id is String ? id : "",
      timeMills: timeMills is int ? timeMills : 0,
      cameraOn: cameraOn is bool ? cameraOn : false,
      mute: mute is bool ? mute : false,
      riseHand: riseHand is bool ? riseHand : false,
    );
  }

  @override
  Map<String, dynamic> get source {
    return {
      "id": id,
      "time_mills": timeMills,
      "isCameraOn": _cameraOn,
      "isMute": _mute,
      "handUp": _riseHand,
    };
  }
}
