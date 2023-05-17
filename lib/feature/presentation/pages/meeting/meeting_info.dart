import '../../../../index.dart';

class MeetingInfo {
  final String id;
  final bool isCameraOn;
  final bool isMuted;
  final CameraType cameraType;

  const MeetingInfo({
    required this.id,
    this.isCameraOn = false,
    this.isMuted = true,
    this.cameraType = CameraType.front,
  });

  @override
  String toString() {
    return "MeetingInfo ($id, $isCameraOn, $isMuted)";
  }
}
