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
  final User me;
  const Home(this.me);

  @override
  State<Home> createState() => _HomeState(this.me);
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin {

  User _user;

  _HomeState(this._user);

  @override
  void initState() {
    super.initState();
    _user = widget.me;
    _initialSetup();

    }

  @override
  Widget build(BuildContext context) {

    super.build(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Container(
            width: double.maxFinite,
            child: Row(
              children: [
                ProfileImage(
                  imageUrl: _user.photoUrl,
                  online: true,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    children: [
                      Text(
                        _user.username,
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
            Chats(_user),
            ActiveUsers(),
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  void _initialSetup() async {
    final user  =(!_user.active) ? context.read<HomeCubit>().connect(_user) : _user;

    context.read<ChatsCubit>().chats();
    context.read<HomeCubit>().activeUsers(_user);

    context.read<MessageBloc>().add(MessageEvent.onSunscibed(_user));

  }
}
