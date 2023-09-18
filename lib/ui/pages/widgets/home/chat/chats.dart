import 'package:chat2/colors.dart';
import 'package:chat2/theme.dart';
import 'package:chat2/ui/pages/home/home/profile_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Chats extends StatefulWidget {
  const Chats();

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.only(top: 30.0, right: 16.0),
        itemBuilder: (_, index) => _chatItem(),
        separatorBuilder: (_, __) => Divider(),
        itemCount: 3);
  }

  _chatItem() {
    return ListTile(
      contentPadding: EdgeInsets.only(left: 16.0),
      leading: ProfileImage(
        imageUrl: "",
        online: true,
      ),
      title: Text(
        'Lisa',
        style: Theme.of(context).textTheme.subtitle2?.copyWith(
              fontWeight: FontWeight.bold,
              color: isLightTheme(context) ? Colors.black : Colors.white,
            ),
      ),
      subtitle: Text(
        'Thank you very much',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        softWrap: true,
        style: Theme.of(context).textTheme.overline?.copyWith(
              fontWeight: FontWeight.bold,
              color: isLightTheme(context) ? Colors.black54 : Colors.white70,
            ),
      ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '12 pm',
            style: Theme.of(context).textTheme.overline?.copyWith(
                  color:
                      isLightTheme(context) ? Colors.black54 : Colors.white70,
                ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50.0),
              child: Container(
                height: 15.0,
                width: 15.0,
                color: kPrimary,
                alignment: Alignment.center,
                child: Text(
                  '2',
                  style: Theme.of(context).textTheme.overline?.copyWith(
                        color: Colors.white,
                      ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
