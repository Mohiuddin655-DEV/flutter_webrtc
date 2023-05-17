import 'package:flutter/material.dart';
import 'package:flutter_andomie/widgets.dart';

class JoinFragment extends StatelessWidget {
  final TextEditingController codeController;

  const JoinFragment({
    Key? key,
    required this.codeController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LinearLayout(
      crossGravity: CrossAxisAlignment.start,
      mainGravity: MainAxisAlignment.start,
      padding: 24,
      children: [
        const TextView(
          text: "Enter the code provided by the meeting organizer",
          textColor: Colors.black,
          textSize: 14,
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: TextField(
            controller: codeController,
            decoration: const InputDecoration(
              hintText: "Example: abc-mnop-xyz",
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }
}
