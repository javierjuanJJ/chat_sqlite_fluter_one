import 'package:chat1/chat.dart';
import 'package:chat2/colors.dart';
import 'package:chat2/states_management/home/chats_cubit.dart';
import 'package:chat2/states_management/home/home_state.dart';
import 'package:chat2/states_management/message/message_bloc.dart';
import 'package:chat2/states_management/message_group/message_group_bloc.dart';
import 'package:chat2/states_management/onboarding/profile_image_cubit.dart';
import 'package:chat2/states_management/shared/header_status.dart';
import 'package:chat2/ui/pages/home/home/profile_image.dart';
import 'package:chat2/ui/pages/home/home_router.dart';
import 'package:chat2/ui/pages/widgets/home/active/active_users.dart';
import 'package:chat2/ui/pages/widgets/home/chat/chats.dart';
import 'package:chat2/viewmodels/chat_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../states_management/home/home_cubit.dart';

class Home extends StatefulWidget {
  final User me;
  final IHomeRouter router;
  final Chats_View_Model viewModel;

  const Home(this.viewModel, this.router, this.me);

  @override
  State<Home> createState() => _HomeState(this.me);
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin {
  User _user;
  List<User> _activeUsers = [];

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
          title: HeaderStatus(
            _user.username,
            _user.photoUrl,
            _user.active,
            description: 'Last seen: ${_user.lastSeen.toString()}',
            typing: 'Typing... ',
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
                      builder: (_, state) {
                        if (state is HomeSuccess) {
                          _activeUsers = state.onlineUsers;
                          return Text('Active (${state.onlineUsers.length})');
                        } else {
                          return Text('Active (0)');
                        }
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Chats(_user, widget.router),
            ActiveUsers(widget.router, _user),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: kPrimary,
          child: Icon(
            Icons.group_add_rounded,
            color: Colors.white,
          ),
          onPressed: () async {
            await widget.router.onShowCreateGroup(context, _activeUsers, _user);
          },
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  void _initialSetup() async {
    final user =
        (!_user.active) ? context.read<HomeCubit>().connect(_user) : _user;

    context.read<ChatsCubit>().chats();
    context.read<HomeCubit>().activeUsers(_user);

    context.read<MessageBloc>().add(MessageEvent.onSunscibed(_user));
    context.read<MessageGroupBloc>().add(MessageGroupEvent.onSunscibed(_user));
  }
}
