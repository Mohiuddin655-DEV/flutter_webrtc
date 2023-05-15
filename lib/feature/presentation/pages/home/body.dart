import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../index.dart';

class HomeBody extends StatefulWidget {
  final HomeBodyType type;

  const HomeBody({
    Key? key,
    required this.type,
  }) : super(key: key);

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  late HomeController controller;

  @override
  void initState() {
    controller = context.read<HomeController>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.type) {
      case HomeBodyType.initial:
        return HomeFragment(controller: controller);
    }
  }
}

enum HomeBodyType {
  initial,
}
