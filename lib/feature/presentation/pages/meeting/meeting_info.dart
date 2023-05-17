import '../../../../index.dart';

class MeetingInfo {
  String id;
  bool isCameraOn;
  bool isMuted;
  bool isSilent;
  CameraType cameraType;

  bool get isFrontCamera => cameraType == CameraType.front;

  MeetingInfo({
    required this.id,
    this.isCameraOn = true,
    this.isMuted = true,
    this.isSilent = false,
    this.cameraType = CameraType.front,
  });

  MeetingInfo attach({
    String? id,
    bool? isCameraOn,
    bool? isMuted,
    bool? isSilent,
    CameraType? cameraType,
  }) {
    return MeetingInfo(
      id: id ?? this.id,
      isCameraOn: isCameraOn ?? this.isCameraOn,
      isMuted: isMuted ?? this.isMuted,
      isSilent: isSilent ?? this.isSilent,
      cameraType: cameraType ?? this.cameraType,
    );
  }

  @override
  String toString() {
    return "MeetingInfo ($id, $isCameraOn, $isMuted, $isSilent, $cameraType)";
  }
}
