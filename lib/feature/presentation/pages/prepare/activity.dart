import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../index.dart';

typedef OnPrepare = Function(BuildContext context, MeetingInfo info);

class PrepareActivity extends StatelessWidget {
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
  Widget build(BuildContext context) {
    print(meetingId);
    return MultiBlocProvider(
      providers: [
        homeController != null
            ? BlocProvider.value(value: homeController!)
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
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.volume_up_outlined,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.info_outline,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
        body: PrepareFragment(
          id: meetingId,
          onPrepare: (context, info) => Navigator.pushReplacementNamed(
            context,
            MeetingActivity.route,
            arguments: {
              "data": info,
              "HomeController": context.read<HomeController>(),
            },
          ),
        ),
      ),
    );
  }
}
