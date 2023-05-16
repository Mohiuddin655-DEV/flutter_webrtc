import 'package:appeler/feature/index.dart';
import 'package:flutter/material.dart';

class HomeGroupFragment extends StatefulWidget {
  const HomeGroupFragment({super.key});

  @override
  State<HomeGroupFragment> createState() => _HomeGroupFragmentState();
}

class _HomeGroupFragmentState extends State<HomeGroupFragment> {
  String? _oldRoomId;
  final _textController = TextEditingController();

  void _resetState() {
    setState(() {
      _oldRoomId = null;
      _textController.text = '';
    });
  }

  @override
  void initState() {
    _textController.addListener(() {
      setState(() {
        _oldRoomId = _textController.text;
        if (_oldRoomId!.isEmpty) _oldRoomId = null;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
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
                      ).then((value) => _resetState());
                    }
                  : null,
              child: const Text(
                'Join Room',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
