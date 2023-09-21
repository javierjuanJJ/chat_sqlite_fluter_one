import 'dart:html';

import 'package:chat1/chat.dart';
import 'package:chat2/models/chat.dart';
import 'package:chat2/states_management/home/home_cubit.dart';
import 'package:chat2/states_management/home/home_state.dart';
import 'package:chat2/ui/pages/home/home/profile_image.dart';
import 'package:chat2/ui/pages/home/home_router.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ActiveUsers extends StatefulWidget {
  final User me;
  final IHomeRouter router;
  const ActiveUsers(this.router, this.me);

  @override
  State<ActiveUsers> createState() => _ActiveUsersState();
}

class _ActiveUsersState extends State<ActiveUsers> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(builder: (_, state){
      if (state is HomeLoading) {
        return Center(child: CircularProgressIndicator(),);
      }
      if (state is HomeSuccess) {
        return _buildList(state.onlineUsers);
      }
      return Container();
    });
  }

  _listItem(User user) {
    return ListTile(
      leading: ProfileImage(
        imageUrl: user.photoUrl,
        online: true,
      ),
      title: Text(
        "",
        style: Theme.of(context)
            .textTheme
            .caption
            ?.copyWith(fontSize: 14.0, fontWeight: FontWeight.bold),
      ),
    );
  }

  _buildList(List<User> users) {
    return ListView.separated(
        itemBuilder: (BuildContext context, _index) => GestureDetector(
          child: _listItem(users[_index]),
          onTap: () => this.widget.router.onShowMessageThread(
              context,
              [users[_index]],
              widget.me,
              Chat(users[_index].id, ChatType.individual)),
        ),
        separatorBuilder: (_, __) => Divider(),
        itemCount: users.length);
  }

}
