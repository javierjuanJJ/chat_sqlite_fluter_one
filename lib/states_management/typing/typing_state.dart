part of "typing_bloc.dart";
abstract class TypingNotificationState extends Equatable {
  const TypingNotificationState();
  factory TypingNotificationState.initial()=> TypingInitial();
  factory TypingNotificationState.sent()=> TypingSentSuccess();
  factory TypingNotificationState.received(TypingEvent event)=> TypingReceivedSuccess(event);



  @override
  List<Object> get props => [];

}
class TypingInitial extends TypingNotificationState {

}

class TypingSentSuccess extends TypingNotificationState {
  late TypingNotificationEvent _typingEvent;
  TypingSentSuccess();
  @override
  List<Object> get props => [_typingEvent];
}

class TypingReceivedSuccess extends TypingNotificationState {
  final TypingEvent _typingEvent;
  const TypingReceivedSuccess(this._typingEvent);
  @override
  List<Object> get props => [_typingEvent];
}