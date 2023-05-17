import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../index.dart';

class PrepareFragment extends StatefulWidget {
  final String id;
  final OnPrepare onPrepare;

  const PrepareFragment({
    Key? key,
    required this.id,
    required this.onPrepare,
  }) : super(key: key);

  @override
  State<PrepareFragment> createState() => _PrepareFragmentState();
}

class _PrepareFragmentState extends State<PrepareFragment> {
  bool isCameraOn = false;
  bool isMuted = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 16,
            ),
            child: Text(
              widget.id,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 24,
              ),
            ),
          ),
          MeetingCamera(
            onCameraStateChange: (value) {
              isCameraOn = value;
            },
            onMicroStateChange: (value) {
              isMuted = value;
            },
          ),
          //const ShareScreenButtonForPrepareBody(),
          Container(
            margin: const EdgeInsets.only(
              top: 16,
            ),
            child: const Text(
              "You are the first one here",
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 24),
            color: Colors.black12,
            height: 1,
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.shield_outlined,
                  color: Colors.black,
                  size: 24,
                ),
                SizedBox(
                  width: 24,
                ),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      text: "This meeting is secured with cloud encryption. ",
                      children: [
                        TextSpan(
                          text: "Learn more",
                          style: TextStyle(
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
            child:  Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  color: Colors.black,
                  size: 24,
                ),
                const SizedBox(
                  width: 24,
                ),
                const Text(
                  "Joining info",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                ImageButton(
                  icon: Icons.share_outlined,
                  tint: Colors.black,
                  size: 24,
                  onClick: (){
                    print(widget.id);
                    Share.share(widget.id, subject: "Let's go to meeting ... ");
                  },
                ),
              ],
            ),
          ),
          AppIconButton(
            text: "Join",
            icon: Icons.videocam_outlined,
            margin: const EdgeInsets.all(32),
            onPressed: () => widget.onPrepare(context, MeetingInfo(
              id: widget.id,
              isCameraOn: isCameraOn,
              isMuted: isMuted,
            )),
          ),
        ],
      ),
    );
  }
}