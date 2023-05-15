import 'package:flutter/material.dart';
import 'package:flutter_andomie/widgets.dart';

import '../../../../index.dart';

class HomeFragment extends StatelessWidget {
  final HomeController controller;

  const HomeFragment({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Center(
      child: TextView(
        text: HomeActivity.title,
        background: Colors.red,
        borderRadius: 24,
        paddingHorizontal: 24,
        paddingVertical: 12,
        onClick: (c){
          controller.signOut();
        },
      ),
    );
  }
}
