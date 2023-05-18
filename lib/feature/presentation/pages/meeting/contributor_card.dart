import 'package:appeler/feature/presentation/pages/meeting/contributor_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import '../../../../index.dart';

class ContributorCard extends StatefulWidget {
  final RTCVideoRenderer renderer;
  final String meetingId;
  final String uid;

  const ContributorCard({
    Key? key,
    required this.renderer,
    required this.meetingId,
    required this.uid,
  }) : super(key: key);

  @override
  State<ContributorCard> createState() => _ContributorCardState();
}

class _ContributorCardState extends State<ContributorCard> {
  late final config = SizeConfig.of(context);
  late final controller = context.read<MeetingController>();

  @override
  Widget build(BuildContext context) {
    return ContributorView(
      controller: controller,
      config: config,
      renderer: widget.renderer,
      mirror: true,
      meetingId: widget.meetingId,
      contributorId: widget.uid,
    );
  }
}
