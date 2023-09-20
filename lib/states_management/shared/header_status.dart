import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../ui/pages/home/home/profile_image.dart';

class HeaderStatus extends StatelessWidget {
  final String username;
  final String imageUrl;
  final bool online;
  final DateTime? lastSeen;
  final bool? typing;

  const HeaderStatus(
    this.username,
    this.imageUrl,
    this.online, {
    this.lastSeen,
    this.typing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      child: Row(
        children: [
          ProfileImage(
            imageUrl: imageUrl,
            online: true,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  children: [
                    Text(
                      username.trim(),
                      style: Theme.of(context).textTheme.caption?.copyWith(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: typing == null
                ? Text(
                    online
                        ? "Online"
                        : "Last seen ${DateFormat.yMd().add_jm().format(lastSeen!)}",
                    style: Theme.of(context).textTheme.caption,
                  )
                : Text(
                    'Typing...',
                    style: Theme.of(context).textTheme.caption?.
                    copyWith(fontStyle: FontStyle.italic),
                  ),
          ),
        ],
      ),
    );
  }
}
