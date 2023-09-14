import 'dart:async';
import 'dart:html';

import 'package:bloc/bloc.dart';
import 'package:chat1/chat.dart';
import 'package:equatable/equatable.dart';

part 'typing_event.dart';
part 'typing_state.dart';

class TypingNotificationBloc extends Bloc<TypingNotificationEvent, TypingNotificationState> {
  final ITypingNotification _typingService;
  late StreamSubscription _subscription;

  TypingNotificationBloc(this._typingService): super(TypingNotificationState.initial());

  @override
  Stream<TypingNotificationState> mapEventToTable(TypingNotificationEvent typingEvent) async* {
    if (typingEvent is Sunscribed){
      if (typingEvent.usersWithChat == null) {
        add(NotSunscribed());
        return;
      }
      await _subscription?.cancel();
      _subscription = _typingService.subscribe(typingEvent.user, typingEvent.usersWithChat).listen((event) => add(TypingReceived(event)));
    }
    if (typingEvent is TypingReceived){
      yield TypingNotificationState.received(typingEvent.event);
    }
    if (typingEvent is TypingSent){
      await _typingService.send(event: typingEvent.receipt);
      yield TypingNotificationState.sent();
    }

    if (typingEvent is NotSunscribed){
      yield TypingNotificationState.initial();
    }

  }

  @override
  Future<void> close(){
    _subscription?.cancel();
    _typingService.dispose();
    return super.close();
  }

}