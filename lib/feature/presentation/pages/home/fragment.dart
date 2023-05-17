import 'package:flutter/material.dart';
import 'package:flutter_andomie/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../index.dart';

class HomeFragment extends StatefulWidget {
  final HomeController controller;

  const HomeFragment({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<HomeFragment> createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {
  late HomeController controller;


  @override
  void initState() {
    controller = context.read<HomeController>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LinearLayout(
      width: double.infinity,
      background: Colors.white,
      children: [
        LinearLayout(
          orientation: Axis.horizontal,
          paddingHorizontal: 8,
          children: [
            TextView(
              flex: 1,
              text: "New meeting",
              textColor: Colors.white,
              textSize: 14,
              background: AppColors.primary,
              borderRadius: 24,
              paddingHorizontal: 16,
              paddingVertical: 12,
              margin: 8,
              textAlign: TextAlign.center,
              onClick: (context) {
                var roomId = controller.generateRoom();
                if (roomId != null) {
                  Navigator.pushNamed(
                    context,
                    PrepareActivity.route,
                    arguments: {
                      "meeting_id": roomId,
                      "HomeController": controller,
                    },
                  );
                }
              },
            ),
            TextView(
              flex: 1,
              text: "Join with a code",
              textColor: AppColors.primary,
              textSize: 14,
              borderColor: AppColors.primary,
              background: Colors.white,
              borderRadius: 24,
              borderSize: 1,
              paddingHorizontal: 16,
              paddingVertical: 12,
              textAlign: TextAlign.center,
              margin: 8,
              onClick: (context) => Navigator.pushNamed(
                context,
                JoinActivity.route,
                arguments: {
                  "HomeController": context.read<HomeController>(),
                }
              ),
            ),
          ],
        ),
      ],
    );
  }
}
