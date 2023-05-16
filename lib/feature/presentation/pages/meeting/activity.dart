import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';
import 'package:flutter_andomie/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../index.dart';

class MeetingActivity extends StatelessWidget {
  static const String route = "meeting";
  static const String title = "Meeting";

  final String meetingId;

  const MeetingActivity({
    Key? key,
    required this.meetingId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => locator<MeetingController>()),
      ],
      child: BlocConsumer<MeetingController, Response<dynamic>>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0.5,
              title: const RawText(
                text: title,
                textColor: Colors.black,
                textSize: 20,
              ),
              iconTheme: const IconThemeData(
                color: Colors.black,
              ),
              actions: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black.withAlpha(05)),
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.only(right: 8),
                        child: RawIcon(
                          icon: Icons.logout_outlined,
                          tint: Colors.black.withAlpha(150),
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
            body: MeetingFragment(
              meetingId: meetingId,
            ),
          );
        },
      ),
    );
  }
}
