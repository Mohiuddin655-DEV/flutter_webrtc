import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import '../../../../index.dart';

class RemoteContributor extends StatefulWidget {
  final RTCVideoRenderer renderer;
  final String meetingId;
  final String uid;

  const RemoteContributor({
    Key? key,
    required this.renderer,
    required this.meetingId,
    required this.uid,
  }) : super(key: key);

  @override
  State<RemoteContributor> createState() => _RemoteContributorState();
}

class _RemoteContributorState extends State<RemoteContributor> {
  late final config = SizeConfig.of(context);
  late final controller = context.read<MeetingController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 150,
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(config.dx(8)),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          RTCVideoView(
            widget.renderer,
            mirror: true,
          ),
          _Buttons(
            controller: controller,
            config: config,
            meetingId: widget.meetingId,
            uid: widget.uid,
          ),
        ],
      ),
    );
  }
}

class _Buttons extends StatelessWidget {
  final MeetingController controller;
  final SizeConfig config;
  final String meetingId;
  final String uid;

  const _Buttons({
    Key? key,
    required this.controller,
    required this.config,
    required this.meetingId,
    required this.uid,
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
          stream: controller.handler.liveContributor(meetingId, uid),
          builder: (context, state) {
            var item = state.data ?? Contributor();
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
          }),
    );
  }
}
