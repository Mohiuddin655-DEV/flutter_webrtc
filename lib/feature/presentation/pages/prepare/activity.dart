import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../index.dart';

typedef OnPrepare = Function(BuildContext context, MeetingInfo info);

class PrepareActivity extends StatefulWidget {
  static const String route = "prepare";
  static const String title = "Prepare";

  final HomeController? homeController;
  final String meetingId;

  const PrepareActivity({
    Key? key,
    required this.meetingId,
    required this.homeController,
  }) : super(key: key);

  @override
  State<PrepareActivity> createState() => _PrepareActivityState();
}

class _PrepareActivityState extends State<PrepareActivity> {
  late bool isSilent = false;
  late bool isFrontCamera = true;

  @override
  Widget build(BuildContext context) {
    print(widget.meetingId);
    return MultiBlocProvider(
      providers: [
        widget.homeController != null
            ? BlocProvider.value(value: widget.homeController!)
            : BlocProvider(create: (context) => locator<HomeController>())
      ],
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          actionsIconTheme: const IconThemeData(
            color: Colors.black,
          ),
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          actions: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    ImageButton(
                      onClick: () {
                        isFrontCamera = !isFrontCamera;
                        setState(() {});
                      },
                      icon: isFrontCamera
                          ? Icons.camera_front_outlined
                          : Icons.camera_rear_outlined,
                      tint: Colors.black.withAlpha(150),
                    ),
                    ImageButton(
                      onClick: () {
                        isSilent = !isSilent;
                        setState(() {});
                      },
                      icon: isSilent
                          ? Icons.volume_off_outlined
                          : Icons.volume_up_outlined,
                      tint: Colors.black.withAlpha(150),
                    ),
                    ImageButton(
                      onClick: () {},
                      icon: Icons.info_outline,
                      tint: Colors.black.withAlpha(150),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
        body: PrepareFragment(
          info: MeetingInfo(
            id: widget.meetingId,
            isCameraOn: true,
            isSilent: isSilent,
            isMuted: true,
            cameraType: isFrontCamera ? CameraType.front : CameraType.back,
          ),
          onPrepare: (context, info) {
            Navigator.pushReplacementNamed(
              context,
              MeetingActivity.route,
              arguments: {
                "data": info,
                "HomeController": context.read<HomeController>(),
              },
            );
          },
        ),
      ),
    );
  }
}
