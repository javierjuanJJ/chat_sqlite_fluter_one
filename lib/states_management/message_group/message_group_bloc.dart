import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat1/chat.dart';
import 'package:chat2/states_management/message/message_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/group/group_service.dart';
import '';
import '../../models/message_group.dart';

part 'message_group_event.dart';
part 'message_group_state.dart';
class MessageGroupBloc extends Bloc<MessageGroupEvent, MessageGroupState> {
  final IGroupService _typingService;
  late StreamSubscription _subscription;

  MessageGroupBloc(this._typingService): super(MessageGroupState.initial());

  @override
  Stream<MessageGroupState> mapEventToTable(MessageGroupEvent typingEvent) async* {
    if (typingEvent is Sunscribed){
      await _subscription?.cancel();

      _subscription = _typingService.groups(me: typingEvent.user).listen((group) {

        add(MessageGroupReceived(group) as MessageGroupEvent);
      });
    }
    if (typingEvent is MessageGroupReceived){
      final v = (typingEvent  as MessageGroupReceived);
      yield MessageGroupState.received(v.group);
    }
    if (typingEvent is MessageGroupCreatedSuccess){
      final v = (typingEvent  as MessageGroupCreatedSuccess);
      final group = await _typingService.create(v.group);
      yield MessageGroupState.created(group);
    }

    if (typingEvent is NotSunscribed){
      yield MessageGroupState.initial();
    }

  }

  @override
  Future<void> close(){
    print("dispose called");
    _subscription?.cancel();
    _typingService.dispose();
    return super.close();
  }

}