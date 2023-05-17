import 'package:flutter/material.dart';

class LinkInviteView extends StatelessWidget {
  final String id;
  final Function()? onCopy;
  final Function()? onInvite;

  const LinkInviteView({
    Key? key,
    required this.id,
    this.onCopy,
    this.onInvite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "You're the only one here",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 16),
            child: const Text(
              "Share this meeting link with others you want in the meeting",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                height: 1.4,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
              top: 24,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "meet.google.com/$id",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                GestureDetector(
                  onTap: onCopy,
                  child: const AbsorbPointer(
                    child: Icon(
                      Icons.copy,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onInvite,
            child: AbsorbPointer(
              child: Container(
                margin: const EdgeInsets.only(
                  top: 24,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue.shade200,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.share_outlined,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Text(
                      "Share invite",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
