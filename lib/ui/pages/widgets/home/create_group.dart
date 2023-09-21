import 'package:chat1/chat.dart';
import 'package:chat2/colors.dart';
import 'package:chat2/states_management/home/chats_cubit.dart';

import 'package:chat2/states_management/home/group_cubit.dart';
import 'package:chat2/states_management/message_group/message_group_bloc.dart';
import 'package:chat2/theme.dart';
import 'package:chat2/ui/pages/home/home/profile_image.dart';
import 'package:chat2/ui/pages/home/home_router.dart';
import 'package:chat2/ui/pages/widgets/shared/custom_text.dart';
import 'package:chat2/utils/random_color_generator.dart';
import 'package:chat2/viewmodels/chat_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/chat.dart';
import '../../../../models/message_group.dart';

class CreateGroup extends StatefulWidget {
  final List<User> _activeUsers;
  final User _me;
  final ChatsCubit _chatsCubit;
  final IHomeRouter _router;

  const CreateGroup(
      this._activeUsers, this._me, this._chatsCubit, this._router);

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  List<User> selectedUders = [];
  late GroupCubit _groupCubit;
  late ChatsCubit _chatsCubit;
  late MessageGroupBloc _messageGroupBloc;
  String _groupName = '';


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _chatsCubit = widget._chatsCubit;

    _groupCubit = context.read<GroupCubit>();
    _messageGroupBloc = context.read<MessageGroupBloc>();

    _messageGroupBloc.stream.listen((state) async {

      if(state is MessageGroupCreatedSuccess){
        state.group.members.removeWhere((element) => element == widget._me.id);
        final membersId = state.group.members.map((e) => {e:RandomColorGenerator.getColor().value.toString()}).toList();
        final chat = Chat(
          state.group.id,
          ChatType.group,
          membersId: membersId,
          name: _groupName,
        );

        await _chatsCubit.viewModel.createNewChat(chat);
        final chats = await _chatsCubit.viewModel.getChats();
        final receivers = chats.firstWhere((chat) => chat.id == state.group.id).members;

        await _chatsCubit.chats();
        Navigator.of(context).pop();
        widget._router.onShowMessageThread(context, receivers!, widget._me, chat);
      }

    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<GroupCubit, List<User>>(
        bloc: _groupCubit,
        builder: (_, state) {
          selectedUders = state;
          return SizedBox.expand(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _header(selectedUders.length > 1),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 16.0),
                    child: CustomTextField(
                        hint: 'Group name',
                        onchanged: (val) {
                          _groupName = val;
                        },
                        inputAction: TextInputAction.done),
                  ),
                  state.isEmpty ?
                      SizedBox.shrink()
                      : Container(
                        height: 65,
                    child: ListView.builder(itemBuilder: (__,idx) => _selectedUsersListItem(selectedUders[idx]),
                    itemCount: selectedUders.length,
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 16.0),),
                  ),
                  Expanded(child: _buildList(widget._activeUsers)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  _header(bool enableButton) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Container(
          height: 40,
          child: Row(
            children: [
              TextButton(
                style: ButtonStyle(
                  textStyle: MaterialStateProperty.all<TextStyle?>(
                      Theme.of(context).textTheme.caption),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancel'),
              ),
              Center(
                child: Text(
                  'New Group',
                  style: Theme.of(context).textTheme.caption,
                ),
              ),
              TextButton(
                style: ButtonStyle(
                  textStyle: MaterialStateProperty.all<TextStyle?>(
                      Theme.of(context).textTheme.caption),
                ),
                onPressed: enableButton
                    ? () {
                        if (_groupName.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Enter Group Name'),
                          ));

                          return;
                        }
                        _createGroup();
                      }
                    : null,
                child: Text('Create'),
              ),
            ],
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
        ),
      );

  void _createGroup() {
    MessageGroup group = MessageGroup(
        name: _groupName,
        createdBy: widget._me.id,
        members: selectedUders.map((e) => e.id).toList() + [widget._me.id]);
    final event = MessageGroupEvent.onGroupCreated(group);
    _messageGroupBloc.add(event);
  }

  _selectedUsersListItem(User user) => Padding(
      padding: const EdgeInsets.only(right: 8.0),
    child: GestureDetector(
      onTap: ()=> _groupCubit.remove(user),
      child: Container(
        width: 40,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: CircleAvatar(
                backgroundColor: kIconLight,
                radius: 30,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Image.network(
                      user.photoUrl,
                    fit: BoxFit.fill,
                    width: 40,
                    height: 40,
                  ),
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 8.0),
              child: Align(
                alignment: Alignment.topRight,
                child: Container(
                  width: 16,
                  height: 16,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isLightTheme(context) ?
                        Colors.black54:
                        kAppBarDark
                  ),
                  child: Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                    size: 12.0,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                user.username.split(' ').first,
                softWrap: false,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.caption?.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  _buildList(List<User> activeUsers) => ListView.separated(
      itemBuilder: (BuildContext context, indx) => GestureDetector(
        child: _listItem(activeUsers[indx]),
        onTap: (){
          if (selectedUders.any((element) => element.id == activeUsers[indx].id)){
            _groupCubit.remove(activeUsers[indx]);
            return;
          }
          _groupCubit.add(activeUsers[indx]);
        },
      ),
      separatorBuilder: (_,__) => Divider(
        endIndent: 16.0,
      ),
      itemCount: activeUsers.length
  );

  _listItem(User activeUser) => ListTile(
    leading: ProfileImage(
      imageUrl: activeUser.photoUrl,
      online: true,
    ),
    title: Text(
      activeUser.username,
      style: Theme.of(context).textTheme.caption?.copyWith(
        fontSize: 12.0,
        fontWeight: FontWeight.bold
      ),
    ),
    trailing: _checkBox(
      size: 20.0,
      isChecked: selectedUders.any((element) => element.id == activeUser.id),
    ),
  );

  _checkBox({required double size, required bool isChecked}) => ClipRRect(
    borderRadius: BorderRadius.circular(size / 2),
    child: AnimatedContainer(
      duration: Duration(microseconds: 500),
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: isChecked ? kPrimary : Colors.transparent,
        border: Border.all(
          color: Colors.grey
        ),
        borderRadius: BorderRadius.circular(size / 2),
      ),
    ),
  );
}
