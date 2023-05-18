import 'package:flutter/material.dart';

import '../../index.dart';

class MeetingCamera extends StatefulWidget {
  final bool initialCameraEnable;
  final bool initialMuteEnable;
  final CameraType cameraType;
  final Function(bool isCameraOn) onCameraStateChange;
  final Function(bool isMicroOn) onMicroStateChange;

  const MeetingCamera({
    Key? key,
    this.initialCameraEnable = false,
    this.initialMuteEnable = true,
    this.cameraType = CameraType.front,
    required this.onCameraStateChange,
    required this.onMicroStateChange,
  }) : super(key: key);

  @override
  State<MeetingCamera> createState() => _MeetingCameraState();
}

class _MeetingCameraState extends State<MeetingCamera> {
  late bool isCameraOn = widget.initialCameraEnable;
  late bool isMuted = widget.initialMuteEnable;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 250,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (isCameraOn)
            SizedBox(
              width: 150,
              height: 250,
              child: CameraView(
                type: widget.cameraType,
              ),
            ),
          Container(
            width: 80,
            height: 80,
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: Image.network(
              "https://assets.materialup.com/uploads/b78ca002-cd6c-4f84-befb-c09dd9261025/preview.png",
              fit: BoxFit.fill,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ImageButton(
                    icon: isCameraOn
                        ? Icons.videocam
                        : Icons.videocam_off_outlined,
                    background: Colors.white24,
                    tint: Colors.white,
                    onClick: () {
                      isCameraOn = !isCameraOn;
                      widget.onCameraStateChange.call(isCameraOn);
                      setState(() {});
                    },
                  ),
                  ImageButton(
                    icon: isMuted ? Icons.mic_off : Icons.mic,
                    background: Colors.white24,
                    tint: Colors.white,
                    onClick: () {
                      isMuted = !isMuted;
                      widget.onMicroStateChange.call(isMuted);
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
