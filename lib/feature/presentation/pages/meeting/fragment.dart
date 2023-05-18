import 'dart:async';

import 'package:appeler/feature/presentation/pages/meeting/contributor_card.dart';
import 'package:appeler/feature/presentation/pages/meeting/remote_user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import '../../../../index.dart';

class MeetingFragment extends StatefulWidget {
  final MeetingInfo info;

  const MeetingFragment({
    super.key,
    required this.info,
  });

  @override
  State<MeetingFragment> createState() => MeetingFragmentState();
}

class MeetingFragmentState extends State<MeetingFragment> {
  late final controller = context.read<MeetingController>();
  late bool isCameraOn = widget.info.isCameraOn;
  late bool isMute = widget.info.isMuted;
  late bool isFrontCamera = widget.info.isFrontCamera;
  bool isRiseHand = false;
  bool isReserveMode = true;
  int crossAxisCount = 2;

  final _localRenderer = RTCVideoRenderer();
  MediaStream? _localStream;

  final _widgetMap = <String, Widget>{};
  final _addedUser = <String>{};

  StreamSubscription? _roomSubs, _hostSubs;

  Future<MediaStream> get _getUserMediaStream async {
    final mp = <String, dynamic>{
      'audio': true,
      'video': kIsWeb
          ? {'facingMode': 'user'}
          : {
              'width': '640',
              'height': '480',
              'frameRate': '30',
              'facingMode': 'user',
              'optional': [],
            }
    };
    final stream = await navigator.mediaDevices.getUserMedia(mp);
    return stream;
  }

  @override
  void initState() {
    _initLocalRenderer();
    super.initState();
  }

  void _initLocalRenderer() async {
    await _localRenderer.initialize();
    _localStream = await _getUserMediaStream;
    if (!widget.info.isFrontCamera) onCameraSwitch();
    onCameraOn();
    onMute();
    setState(() {
      _localRenderer.srcObject = _localStream;
      _widgetMap['local'] = ContributorCard(
        key: UniqueKey(),
        renderer: _localRenderer,
        meetingId: widget.info.id,
        uid: AuthHelper.uid,
      );
    });
    _setStatus();
    _offerAnswerHostUser();
  }

  void onSilent(bool silent) => Helper.setSpeakerphoneOn(silent);

  void onCameraSwitch() {
    if (_localStream != null) {
      Helper.switchCamera(_localStream!.getVideoTracks()[0]);
    }
  }

  void onCameraOn() {
    if (_localStream != null) {
      _localStream?.getVideoTracks()[0].enabled = isCameraOn;
      _changeStatus(key: 'isCameraOn');
    }
  }

  void onMute() {
    if (_localStream != null) {
      _localStream?.getAudioTracks()[0].enabled = !isMute;
      _changeStatus(key: 'isMute');
    }
  }

  void onRiseHand() {
    _changeStatus(key: 'handUp');
  }

  void _offerAnswerHostUser() {
    _hostSubs = controller.handler
        .getMeetingReference(widget.info.id)
        .snapshots()
        .listen((event) {
      final mp = event.data();
      if (mp != null && mp is Map<String, dynamic>) {
        for (final item in mp.entries) {
          final curItem = item.key;
          if (curItem != AuthHelper.uid && !_addedUser.contains(curItem)) {
            _addedUser.add(curItem);
            _widgetMap[curItem] = RemoteContributor(
              key: UniqueKey(),
              type: AuthHelper.uid.compareTo(curItem) > 0
                  ? ContributorType.outgoing
                  : ContributorType.incoming,
              uid: curItem,
              meetingId: widget.info.id,
              local: _localStream!,
            );
          }
        }
        final list = <String>[];
        for (final item in _widgetMap.entries) {
          if (item.key != 'local' && !mp.containsKey(item.key)) {
            list.add(item.key);
          }
        }
        for (final item in list) {
          _addedUser.remove(item);
          _widgetMap.remove(item);
        }
        setState(() {});
      }
    });
  }

  void _changeStatus({required String key}) {
    controller.handler.changeStatus(
      id: widget.info.id,
      isMute: isMute,
      isRiseHand: isRiseHand,
      isCameraOn: isCameraOn,
      isFrontCamera: isFrontCamera,
    );
  }

  void _setStatus() {
    controller.handler.setStatus(
      id: widget.info.id,
      isMute: isMute,
      isRiseHand: isRiseHand,
      isCameraOn: isCameraOn,
      isFrontCamera: isFrontCamera,
    );
  }

  void _removeStatus() {
    controller.handler.removeStatus(widget.info.id);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          Expanded(
            child: GridView(
              padding: const EdgeInsets.all(24),
              // reverse: isReserveMode,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: 3 / 5,
              ),
              children: _widgetMap.entries.map((e) => e.value).toList(),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 16,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ImageButton(
                  icon: Icons.call_end,
                  tint: Colors.white,
                  background: Colors.red,
                  size: 32,
                  onClick: () => Navigator.pop(context),
                ),
                ImageButton(
                  icon: isCameraOn
                      ? Icons.videocam_outlined
                      : Icons.videocam_off_outlined,
                  tint: isCameraOn ? Colors.black : Colors.white,
                  background: isCameraOn ? Colors.white : Colors.white12,
                  size: 32,
                  onClick: () {
                    isCameraOn = !isCameraOn;
                    setState(onCameraOn);
                  },
                ),
                ImageButton(
                  icon: isMute ? Icons.mic_off : Icons.mic,
                  tint: isMute ? Colors.white : Colors.black,
                  background: isMute ? Colors.white12 : Colors.white,
                  size: 32,
                  onClick: () {
                    isMute = !isMute;
                    setState(onMute);
                  },
                ),
                ImageButton(
                  icon: Icons.back_hand_outlined,
                  tint: isRiseHand ? Colors.black : Colors.white,
                  background: isRiseHand ? Colors.white : Colors.white12,
                  size: 32,
                  onClick: () {
                    isRiseHand = !isRiseHand;
                    setState(onRiseHand);
                  },
                ),
                ImageButton(
                  icon: Icons.more_vert,
                  tint: Colors.white,
                  background: Colors.white12,
                  size: 32,
                  onClick: () {},
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _disposeSubs();
    _removeStatus();
    _disposeLocalRenderer();
    super.dispose();
  }

  void _disposeLocalRenderer() {
    _localRenderer.dispose();
    _localStream?.getTracks().forEach((element) {
      element.stop();
    });
    _localStream?.dispose();
  }

  void _disposeSubs() {
    _hostSubs?.cancel();
    _roomSubs?.cancel();
  }
}
