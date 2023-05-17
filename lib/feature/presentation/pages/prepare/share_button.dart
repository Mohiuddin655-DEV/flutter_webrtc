import 'package:flutter/material.dart';

class ShareScreenButtonForPrepareBody extends StatelessWidget {
  const ShareScreenButtonForPrepareBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: 16,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.circular(6)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(
            Icons.present_to_all,
            size: 20,
            color: Colors.blue,
          ),
          SizedBox(
            width: 8,
          ),
          Text(
            "Share screen",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
