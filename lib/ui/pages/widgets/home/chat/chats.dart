import 'package:chat1/chat.dart';
import 'package:chat2/colors.dart';
import 'package:chat2/states_management/home/chats_cubit.dart';
import 'package:chat2/states_management/message_group/message_group_bloc.dart';
import 'package:chat2/states_management/typing/typing_bloc.dart';
import 'package:chat2/theme.dart';
import 'package:chat2/ui/pages/home/home/profile_image.dart';
import 'package:chat2/ui/pages/home/home_router.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../models/chat.dart';
import '../../../../../states_management/message/message_bloc.dart';
import '../../../../../utils/random_color_generator.dart';

class Chats extends StatefulWidget {
  const Chats(this.user, this.router);
  final IHomeRouter router;
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
      List<String> userIds = [];
      chats.forEach((chat) {
        userIds += chat.members!.map((e) => e.id).toList();
      });
      context.read<TypingNotificationBloc>().add(
        TypingNotificationEvent.onSunscibed(
            widget.user,
            usersWithChat: userIds.toSet().toList()
        ));

      return _buildListView();
    });
  }

  ListView _buildListView() {
    return ListView.separated(
      padding: EdgeInsets.only(top: 30.0, right: 16.0),
        itemBuilder: (_, index) => GestureDetector(
          child: _chatItem(chats[index]),
          onTap: () async {
            await this.widget.router.onShowMessageThread(
                context,
                _chatItem(chats[index].from),
                widget.user,
                chats[index]
            );

            await context.read<ChatsCubit>().chats();
          },
        ),
        separatorBuilder: (_, __) => Divider(),
        itemCount: chats.length);
  }

  _chatItem(Chat chat) {
    return ListTile(
      contentPadding: EdgeInsets.only(left: 16.0),
      leading: ProfileImage(
        imageUrl: chat.type == ChatType.individual ? chat.members?.first.photoUrl : null,
        online: chat.type == ChatType.individual ? chat.members?.first.active : null,
      ),
      title: Text(
        chat.from.username,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: isLightTheme(context) ? Colors.black : Colors.white,
            ),
      ),
      subtitle: BlocBuilder<TypingNotificationBloc,TypingNotificationState>(
        builder: (__, state){

          if(
          state is TypingReceivedSuccess &&
              state.event.event == Typing.start &&
              state.event.chatId == chat.id
          ){
            this.typingEvents.add(state.event.from);
          }

          if(
          state is TypingReceivedSuccess &&
              state.event.event == Typing.stop &&
              state.event.chatId == chat.id
          ){
            this.typingEvents.remove(state.event.from);
          }

          if (this.typingEvents.contains(chat.id)){
            switch(chat.type) {
              case ChatType.group:
                final st = state as TypingReceived;
                final username = chat.members?.firstWhere((element) => element.id == st.event.from);
                return Text(

                    '$username is tyyping...',
                    style: Theme.of(context)
                        .textTheme
                        .caption
                        ?.copyWith(fontStyle: FontStyle.italic)
                );
              case ChatType.individual:
                return Text(

                    'Typing...',
                    style: Theme.of(context)
                        .textTheme
                        .caption
                        ?.copyWith(fontStyle: FontStyle.italic)
                );
            }

          }

          String? username2 = chat.mostRecent != null
                ? chat.type == ChatType.individual
                  ? chat.mostRecent?.message.content : (chat.members
            ?.firstWhere((element) => element.id == chat.mostRecent?.message.from,))!.toString() + ': ' + chat.mostRecent!.message.content : 'Group created';
          return Text(
            username2!,
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
          if (chat.mostRecent != null)
            Text(
                        DateFormat('h:mm: a')
                            .format(chat.mostRecent!.message.timeStap),
                        style: Theme.of(context).textTheme.overline?.
                        copyWith(
                              color:
                                  isLightTheme(context) ? Colors.black54 : Colors.white70,
                            ),
                      )
          ,
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

    context.read<MessageGroupBloc>().stream.listen((state)async {

      if (state is MessageGroupReceived){
        final group = state.group;
        group.members.removeWhere((element) => element == widget.user.id);
        final membersId = group.members.
      map((e) => {
        e: RandomColorGenerator.getColor().value.toString()
        }).toList();
        final chat = Chat(group.id, ChatType.group,name: group.name, membersId: membersId);
        await chatsCubit.viewModel.createNewChat(chat);
        chatsCubit.chats();
      }

    });

  }
}
