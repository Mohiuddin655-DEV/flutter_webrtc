import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../index.dart';

class MeetingActivity extends StatefulWidget {
  static const String route = "meeting";
  static const String title = "Meeting";

  final MeetingInfo data;
  final HomeController? homeController;

  const MeetingActivity({
    Key? key,
    required this.data,
    required this.homeController,
  }) : super(key: key);

  @override
  State<MeetingActivity> createState() => _MeetingActivityState();
}

class _MeetingActivityState extends State<MeetingActivity> {
  late bool isSilent = widget.data.isSilent;
  late bool isFrontCamera = widget.data.isFrontCamera;

  final globalKey = GlobalKey<MeetingFragmentState>();

  @override
  void initState() {
    silent();
    super.initState();
  }

  void silent() {
    globalKey.currentState?.onSilent(isSilent);
  }

  void switchCamera() {
    globalKey.currentState?.onCameraSwitch();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => locator<MeetingController>()),
        widget.homeController != null
            ? BlocProvider.value(value: widget.homeController!)
            : BlocProvider(create: (context) => locator<HomeController>())
      ],
      child: Scaffold(
        backgroundColor: Colors.black,
        extendBody: true,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          centerTitle: false,
          elevation: 0,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.light,
          ),
          backgroundColor: Colors.transparent,
          actionsIconTheme: const IconThemeData(
            color: Colors.white,
          ),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          title: Text(
            widget.data.id,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
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
                        isSilent = !isSilent;
                        setState(silent);
                      },
                      icon: isSilent
                          ? Icons.volume_off_outlined
                          : Icons.volume_up_outlined,
                    ),
                    ImageButton(
                      onClick: () {
                        isFrontCamera = !isFrontCamera;
                        setState(switchCamera);
                      },
                      icon: isFrontCamera
                          ? Icons.camera_front_outlined
                          : Icons.camera_rear_outlined,
                      tint: Colors.white,
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
        body: SafeArea(
          child: MeetingFragment(
            key: globalKey,
            info: widget.data,
          ),
        ),
      ),
    );
  }
}
