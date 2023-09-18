import 'package:chat1/chat.dart';
import 'package:chat2/states_management/home/chats_cubit.dart';
import 'package:chat2/states_management/home/home_state.dart';
import 'package:chat2/states_management/message/message_bloc.dart';
import 'package:chat2/states_management/onboarding/profile_image_cubit.dart';
import 'package:chat2/ui/pages/home/home/profile_image.dart';
import 'package:chat2/ui/pages/widgets/home/active/active_users.dart';
import 'package:chat2/ui/pages/widgets/home/chat/chats.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../states_management/home/home_cubit.dart';

class Home extends StatefulWidget {
  const Home();

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    context.read<ChatsCubit>().chats();
    context.read<HomeCubit>().activeUsers();
    final user = User.fromJson({
      'id': "",
      'active': true,
      'photo_url': "",
      'last_seen': DateTime.now(),
    });
    context.read<MessageBloc>().add(MessageEvent.onSunscibed(user));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Container(
            width: double.maxFinite,
            child: Row(
              children: [
                ProfileImage(
                  imageUrl: "",
                  online: true,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    children: [
                      Text(
                        'Jess',
                        style: Theme.of(context).textTheme.caption?.copyWith(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Column(
                    children: [
                      Text(
                        'Online',
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottom: TabBar(
            indicatorPadding: EdgeInsets.only(top: 10.0, bottom: 10.0),
            tabs: [
              Tab(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text('Message'),
                  ),
                ),
              ),
              Tab(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: BlocBuilder<HomeCubit, HomeState>(
                        builder: (_, state) => state is HomeSuccess
                            ? Text('Active (${state.onlineUsers.length})')
                            : Text('Active (0)')),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Chats(),
            ActiveUsers(),
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => throw UnimplementedError();
}
