import 'package:appeler/feature/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeMemberFragment extends StatefulWidget {
  const HomeMemberFragment({super.key});

  @override
  State<HomeMemberFragment> createState() => _HomeMemberFragmentState();
}

class _HomeMemberFragmentState extends State<HomeMemberFragment> {
  final _groupChatRooms =
      FirebaseFirestore.instance.collection('group-chat-rooms');
  final _textController = TextEditingController();
  String? _oldRoomId;

  void _resetState() {
    setState(() {
      _oldRoomId = null;
      _textController.text = '';
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Expanded(
              flex: 5,
              child: TextField(
                controller: _textController,
                decoration: const InputDecoration(hintText: 'ROOM ID'),
                onChanged: print,
              ),
            ),
            const SizedBox(width: 5),
            Expanded(
              flex: 3,
              child: MaterialButton(
                color: Colors.red,
                onPressed: () {
                  setState(() {
                    if (_oldRoomId != null) {
                      _groupChatRooms.doc(_oldRoomId).delete();
                    }
                    final newDoc = _groupChatRooms.doc();
                    _oldRoomId = newDoc.id;
                    _textController.text = _oldRoomId!;
                    newDoc.set({});
                  });
                },
                child: const Text(
                  'Generate',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(
              width: 5,
            )
          ],
        ),
        const SizedBox(height: 5),
        MaterialButton(
          color: Colors.green,
          disabledColor: Colors.grey,
          onPressed: _oldRoomId != null
              ? () {
                  Navigator.pushNamed(
                    context,
                    MeetingActivity.route,
                    arguments: {
                      "meeting_id": _oldRoomId,
                    },
                  ).then((value) {
                    _resetState();
                  });
                }
              : null,
          child: const Text(
            'Join Room',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
