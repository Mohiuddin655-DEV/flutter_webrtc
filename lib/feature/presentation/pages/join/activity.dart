import 'package:flutter/material.dart';
import 'package:flutter_andomie/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../index.dart';

typedef OnJoin = Function(BuildContext context, String id);

class JoinActivity extends StatefulWidget {
  static const String route = "join";
  static const String title = "Join";

  final HomeController? homeController;

  const JoinActivity({
    Key? key,
    required this.homeController,
  }) : super(key: key);

  @override
  State<JoinActivity> createState() => _JoinActivityState();
}

class _JoinActivityState extends State<JoinActivity> {
  late TextEditingController codeController;

  @override
  void initState() {
    codeController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        widget.homeController != null
            ? BlocProvider.value(value: widget.homeController!)
            : BlocProvider(create: (context) => locator<HomeController>())
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.5,
          centerTitle: false,
          backgroundColor: Colors.white,
          actionsIconTheme: const IconThemeData(
            color: Colors.black,
          ),
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          title: const Text(
            "Join with a code",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          actions: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextView(
                  marginHorizontal: 4,
                  padding: 12,
                  text: "Join",
                  textColor: AppColors.secondary,
                  fontWeight: FontWeight.bold,
                  onClick: (context) {
                    var roomId = codeController.text;
                    if (roomId.isNotEmpty) {
                      Navigator.pushNamed(
                        context,
                        PrepareActivity.route,
                        arguments: {
                          "meeting_id": roomId,
                          "HomeController": context.read<HomeController>(),
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
        body: JoinFragment(
          codeController: codeController,
        ),
      ),
    );
  }
}
