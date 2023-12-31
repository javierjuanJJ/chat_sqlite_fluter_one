import 'dart:async';
import 'dart:html';

import 'package:bloc/bloc.dart';
import 'package:chat1/chat.dart';
import 'package:equatable/equatable.dart';

part './message_event.dart';

part './message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final IMessageService _messageService;
  StreamSubscription? _subscription;

  MessageBloc(this._messageService) : super(MessageState.initial());

  @override
  Stream<MessageState> mapEventToTable(MessageEvent event) async* {
    if (event is Sunscribed) {
      await _subscription?.cancel();
      _subscription =
          _messageService.messages(activeUser: event.user).listen((message) {
        add(_MessageReceived(message));
      });
    }
    if (event is _MessageReceived) {
      yield MessageState.received(event.message);
    }
    if (event is MessageSent) {
      final Message message =
          (await _messageService.send(event.messages)) as Message;
      yield MessageState.sent(message);
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    _messageService.dispose();
    return super.close();
  }
}
