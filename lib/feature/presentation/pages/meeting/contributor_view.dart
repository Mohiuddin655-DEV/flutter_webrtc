import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import '../../../../index.dart';

class ContributorView extends StatelessWidget {
  final MeetingController controller;
  final SizeConfig config;
  final RTCVideoRenderer renderer;
  final bool mirror;
  final String meetingId;
  final String contributorId;

  const ContributorView({
    Key? key,
    required this.controller,
    required this.config,
    required this.renderer,
    required this.mirror,
    required this.meetingId,
    required this.contributorId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(config.dx(8)),
      ),
      child: StreamBuilder(
          stream: controller.handler.liveContributor(meetingId, contributorId),
          builder: (context, state) {
            var item = state.data ?? Contributor();
            return Stack(
              alignment: Alignment.center,
              children: [
                item.isCameraOn
                    ? RTCVideoView(
                        renderer,
                        mirror: true,
                        objectFit:
                            RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                      )
                    : Container(
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
                _Buttons(
                  config: config,
                  item: item,
                ),
              ],
            );
          }),
    );
  }
}

class _Buttons extends StatelessWidget {
  final Contributor item;
  final SizeConfig config;

  const _Buttons({
    Key? key,
    required this.config,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        if (item.isRiseHand)
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.white24,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.back_hand_outlined,
                size: 18,
                color: Colors.white,
              ),
            ),
          ),
        Positioned(
          right: 0,
          top: 0,
          child: Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Colors.white24,
              shape: BoxShape.circle,
            ),
            child: Icon(
              item.isMute ? Icons.mic_off : Icons.mic,
              size: 18,
              color: Colors.white,
            ),
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Colors.white24,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.more_vert,
              size: 18,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
