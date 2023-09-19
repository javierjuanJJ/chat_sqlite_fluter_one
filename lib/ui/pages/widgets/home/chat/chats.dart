import 'package:chat1/chat.dart';
import 'package:chat2/colors.dart';
import 'package:chat2/states_management/home/chats_cubit.dart';
import 'package:chat2/states_management/typing/typing_bloc.dart';
import 'package:chat2/theme.dart';
import 'package:chat2/ui/pages/home/home/profile_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../models/chat.dart';
import '../../../../../states_management/message/message_bloc.dart';

class Chats extends StatefulWidget {
  const Chats(this.user);

  final User user;

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {

  var chats = [];

  final typingEvents = [];


  @override
  void initState() {
    super.initState();
    _updateChatsOnMessageReceiver();
    context.read<ChatsCubit>().chats();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatsCubit, List<Chat>>(builder: (_,chats) {
      this.chats = chats;
      if (this.chats.isEmpty) {
        return Container();
      }
      context.read<TypingNotificationBloc>().add(
        TypingNotificationEvent.onSunscibed(
            widget.user,
            usersWithChat: chats.map((e) => e.from.id).toList()
        ));

      return _buildListView();
    });
  }

  ListView _buildListView() {
    return ListView.separated(
      padding: EdgeInsets.only(top: 30.0, right: 16.0),
        itemBuilder: (_, index) => _chatItem(chats[index]),
        separatorBuilder: (_, __) => Divider(),
        itemCount: chats.length);
  }

  _chatItem(Chat chat) {
    return ListTile(
      contentPadding: EdgeInsets.only(left: 16.0),
      leading: ProfileImage(
        imageUrl: chat.from.photoUrl,
        online: chat.from.active,
      ),
      title: Text(
        chat.from.username,
        style: Theme.of(context).textTheme.subtitle2?.copyWith(
              fontWeight: FontWeight.bold,
              color: isLightTheme(context) ? Colors.black : Colors.white,
            ),
      ),
      subtitle: BlocBuilder<TypingNotificationBloc,TypingNotificationState>(
        builder: (__, state){

          if(
          state is TypingReceivedSuccess &&
              state.event.event == Typing.start &&
              state.event.from == chat.from.id
          ){
            this.typingEvents.add(state.event.from);
          }

          if(
          state is TypingReceivedSuccess &&
              state.event.event == Typing.stop &&
              state.event.from == chat.from.id
          ){
            this.typingEvents.remove(state.event.from);
          }

          if (this.typingEvents.contains(chat.from.id)){
            return Text(
              'Typing...',
              style: Theme.of(context)
                .textTheme
                .caption
                ?.copyWith(fontStyle: FontStyle.italic)
            );
          }


          return Text(
            chat.mostRecent.message.content,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
            style: Theme.of(context).textTheme.overline?.copyWith(
              fontWeight: FontWeight.bold,
              color: isLightTheme(context) ? Colors.black54 : Colors.white70,
            ),
          );
        }
      ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            DateFormat('h:mm: a').format(chat.mostRecent.message.timeStap),
            style: Theme.of(context).textTheme.overline?.copyWith(
                  color:
                      isLightTheme(context) ? Colors.black54 : Colors.white70,
                ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50.0),
              child: chat.unread> 0 ? Container(
                height: 15.0,
                width: 15.0,
                color: kPrimary,
                alignment: Alignment.center,
                child: Text(
                  chat.unread.toString(),
                  style: Theme.of(context).textTheme.overline?.copyWith(
                        color: Colors.white,
                        fontWeight: chat.unread > 0 ? FontWeight.bold : FontWeight.normal
                  ),

                ),
              ) : SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }

  void _updateChatsOnMessageReceiver() {
    final chatsCubit = context.read<ChatsCubit>();
    context.read<MessageBloc>().stream.listen((state) async {
      if (state is MessageReceivedSuccess) {
        await chatsCubit.viewModel.receivedMessage(state.message);
        chatsCubit.chats();
      }
    });

  }
}
