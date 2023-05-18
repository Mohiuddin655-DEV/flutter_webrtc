import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import '../../../../index.dart';
import 'contributor_view.dart';

class RemoteContributor extends StatefulWidget {
  final String uid;
  final String meetingId;
  final MediaStream local;
  final ContributorType type;

  const RemoteContributor({
    super.key,
    required this.uid,
    required this.meetingId,
    required this.local,
    required this.type,
  });

  @override
  State<RemoteContributor> createState() => _RemoteContributorState();
}

class _RemoteContributorState extends State<RemoteContributor> {
  final _chatRooms = FirebaseFirestore.instance.collection('chat-rooms');
  final _curUser =
      FirebaseFirestore.instance.collection('users').doc(AuthHelper.uid);

  late final _curRoom = _chatRooms.doc(widget.type == ContributorType.outgoing
      ? '${AuthHelper.uid}+${widget.uid}'
      : '${widget.uid}+${AuthHelper.uid}');

  late final _curRoomSelfCandidates = _curRoom.collection(
      widget.type == ContributorType.outgoing
          ? 'callerCandidate'
          : 'callieCandidate');
  late final _curRoomRemoteCandidates = _curRoom.collection(
      widget.type == ContributorType.outgoing
          ? 'callieCandidate'
          : 'callerCandidate');

  MediaStream? _remoteStream, _localStream;
  late RTCPeerConnection _peerConnection;

  StreamSubscription? _curRoomSubs, _candidateSubs;

  final _remoteRenderer = RTCVideoRenderer();

  var totalCandidate = 0;

  Future<void> _disposeLocalStream() async {
    _localStream?.getTracks().forEach((element) {
      element.stop();
    });
    _localStream?.dispose();
  }

  void _setRemoteCandidate() {
    Future.delayed(const Duration(seconds: 3)).then((value) {
      _candidateSubs = _curRoomRemoteCandidates.snapshots().listen((event) {
        for (final item in event.docChanges) {
          if (item.type == DocumentChangeType.added) {
            final curData = item.doc.data();
            ++totalCandidate;
            if (curData != null) {
              final candidate = RTCIceCandidate(curData['candidate'],
                  curData['sdpMid'], curData['sdpMLineIndex']);
              _peerConnection.addCandidate(candidate);
            }
          }
        }
      });
    });
  }

  Future<void> _initRemoteRenderer() async {
    await _remoteRenderer.initialize();
  }

  Future<void> _disposeRemoteRenderer() async {
    _remoteRenderer.dispose();
    _remoteStream?.getTracks().forEach((track) {
      track.stop();
    });
    _remoteStream?.dispose();
  }

  Future<RTCPeerConnection> _createPeerConnection() async {
    final config = <String, dynamic>{
      "sdpSemantics": "plan-b",
      'iceServers': [
        {
          "urls": "turn:34.143.165.178:3478?transport=udp",
          "username": "test",
          "credential": "test123",
        },
      ]
    };

    final pc = await createPeerConnection(config);

    pc.addStream(widget.local);

    pc.onIceCandidate = (e) {
      if (e.candidate != null) {
        _curRoomSelfCandidates.add(e.toMap());
      }
    };

    pc.onAddStream = (stream) {
      setState(() {
        _remoteRenderer.srcObject = stream;
        _remoteStream = stream;
      });
    };
    return pc;
  }

  Future<void> _initPeerConnection() async {
    _peerConnection = await _createPeerConnection();
  }

  Future<void> _setRemoteDescription({
    required Map<String, dynamic> sdpMap,
  }) async {
    final description = RTCSessionDescription(sdpMap['sdp'], sdpMap['type']);
    return await _peerConnection.setRemoteDescription(description);
  }

  void _createOffer() async {
    final offer = await _peerConnection.createOffer();
    await _peerConnection.setLocalDescription(offer);
    _curRoom.set({'offer': offer.toMap()});
    _curRoomSubs = _curRoom.snapshots().listen((snapshot) async {
      final sdpMap = snapshot.data()?['answer'];
      if (await _peerConnection.getRemoteDescription() == null &&
          sdpMap != null) {
        await _setRemoteDescription(sdpMap: sdpMap);
      }
    });
  }

  void _createAnswer() async {
    _curRoomSubs = _curRoom.snapshots().listen((snapshot) async {
      final sdpMap = snapshot.data()?['offer'];
      if (await _peerConnection.getRemoteDescription() == null &&
          sdpMap != null) {
        await _setRemoteDescription(sdpMap: sdpMap);
        final answer = await _peerConnection.createAnswer();
        await _peerConnection.setLocalDescription(answer);
        _curRoom.update({'answer': answer.toMap()});
      }
    });
  }

  void _initRendererOfferAnswer() async {
    await _initRemoteRenderer();
    await _initPeerConnection();
    _setRemoteCandidate();
    if (widget.type == ContributorType.outgoing) {
      _createOffer();
    } else {
      _createAnswer();
    }
  }

  Future<void> _deleteInnerCollection() async {
    final innerCollection = await _curRoomSelfCandidates.get();
    for (var item in innerCollection.docs) {
      await item.reference.delete();
    }
  }

  void _deleteRoomAndRecoverState() async {
    await _deleteInnerCollection();
    _curRoom.delete();
    _curUser.update({'inAnotherCall': false, 'incomingCallFrom': null});
  }

  void _cancelSubscriptions() {
    _curRoomSubs?.cancel();
    _candidateSubs?.cancel();
  }

  void _clearPeerConnection() async {
    _disposeLocalStream();
    await _peerConnection.close();
    //_peerConnection.dispose();
  }

  @override
  void initState() {
    _initRendererOfferAnswer();
    Future.delayed(const Duration(seconds: 10)).then((value) {
      print('total candidate is: $totalCandidate');
    });
    super.initState();
  }

  @override
  void dispose() {
    _deleteRoomAndRecoverState();
    _disposeRemoteRenderer();
    _cancelSubscriptions();
    _clearPeerConnection();
    super.dispose();
  }

  late final config = SizeConfig.of(context);
  late final controller = context.read<MeetingController>();

  @override
  Widget build(BuildContext context) {
    return ContributorView(
      controller: controller,
      config: config,
      renderer: _remoteRenderer,
      mirror: true,
      meetingId: widget.meetingId,
      contributorId: widget.uid,
    );
  }
}
