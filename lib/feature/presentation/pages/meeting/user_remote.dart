import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import 'calling_type.dart';

class GroupCallingRemoteScreen extends StatefulWidget {
  const GroupCallingRemoteScreen({
    super.key,
    required this.callEnum,
    required this.id,
    required this.localStream,
  });

  final CallEnum callEnum;
  final String id;
  final MediaStream localStream;

  @override
  State<GroupCallingRemoteScreen> createState() =>
      _GroupCallingRemoteScreenState();
}

class _GroupCallingRemoteScreenState extends State<GroupCallingRemoteScreen> {
  final _chatRooms = FirebaseFirestore.instance.collection('chat-rooms');
  final _curUser =
      FirebaseFirestore.instance.collection('users').doc(AuthHelper.uid);
  late final _curRoom = _chatRooms.doc(widget.callEnum == CallEnum.outgoing
      ? '${AuthHelper.uid}+${widget.id}'
      : '${widget.id}+${AuthHelper.uid}');

  // Future<MediaStream> get _getUserMediaStream async {
  //   final mp = <String, dynamic>{
  //     'audio': true,
  //     'video': kIsWeb
  //         ? {'facingMode': 'user'}
  //         : {
  //       'width': '640',
  //       'height': '480',
  //       'frameRate': '30',
  //       'facingMode': 'user',
  //       'optional': [],
  //     }
  //   };
  //   final stream = await navigator.mediaDevices.getUserMedia(mp);
  //   return stream;
  // }

  //late final _curRoom = _chatRooms.doc();

  late final _curRoomSelfCandidates = _curRoom.collection(
      widget.callEnum == CallEnum.outgoing
          ? 'callerCandidate'
          : 'callieCandidate');
  late final _curRoomRemoteCandidates = _curRoom.collection(
      widget.callEnum == CallEnum.outgoing
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
            print(
                'new remote added candidate is: $curData and id is: ${item.doc.id}');
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
    //_peerConnection.dispose();
  }

  Future<RTCPeerConnection> _createPeerConnection() async {
    final config = <String, dynamic>{
      "sdpSemantics": "plan-b", //this line is added
      'iceServers': [
        //{ "url": "stun:34.143.165.178:3478" },
        {
          "urls": "turn:34.143.165.178:3478?transport=udp",
          "username": "test",
          "credential": "test123",
        },
        // {
        //   "url": "turn:180.210.129.103:3478?transport=udp",
        //   "username": "citlrtc",
        //   "credential": "c1tlr7c",
        // }
        // {
        //   "urls": "turn:openrelay.metered.ca:80",
        //   "username": "openrelayproject",
        //   "credential": "openrelayproject",
        // }
      ]
    };

    final pc = await createPeerConnection(config);

    //_localStream = await _getUserMediaStream;
    //await pc.addStream(_localStream!);

    pc.addStream(widget.localStream);

    // widget.localStream.getTracks().forEach((track) {
    //   pc.addTrack(track, widget.localStream);
    // });

    pc.onIceCandidate = (e) {
      if (e.candidate != null) {
        _curRoomSelfCandidates.add(e.toMap());
        //_curRoomSelfCandidates.doc((++_docId).toString()).set(e.toMap());
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

  Future<void> _setRemoteDescription(
      {required Map<String, dynamic> sdpMap}) async {
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
    if (widget.callEnum == CallEnum.outgoing) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _remoteStream == null
          ? const Center(child: CircularProgressIndicator())
          : Container(
              key: UniqueKey(),
              margin: const EdgeInsets.all(16),
              decoration: const BoxDecoration(color: Colors.black),
              child: RTCVideoView(_remoteRenderer, mirror: true),
            ),
    );
  }
}
