import 'package:flutter/material.dart';
import 'package:flutter_andomie/widgets.dart';

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

class _HomeFragmentState extends State<HomeFragment>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  late ViewPagerController pager;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    pager = ViewPagerController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LinearLayout(
      background: Colors.black.withAlpha(50),
      children: [
        TabLayout(
          background: Colors.white,
          height: kToolbarHeight,
          tabTitleSize: 16,
          paddingBottom: 4,
          paddingTop: 10,
          tabTitleWeightState: const ValueState(
            primary: FontWeight.normal,
            selected: FontWeight.bold,
          ),
          tabContentColorState: const ValueState(
            primary: Colors.grey,
            selected: AppColors.primary,
          ),
          tabController: tabController,
          pagerController: pager,
          tabs: const [
            TabItem(
              index: 0,
              title: "Users",
            ),
            TabItem(
              index: 1,
              title: "Group",
            ),
          ],
        ),
        ViewPager(
          flex: 1,
          controller: pager,
          items: const [
            HomeMemberFragment(),
            HomeGroupFragment(),
          ],
        ),
      ],
    );
  }
}
