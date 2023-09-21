part of "typing_bloc.dart";

abstract class TypingNotificationEvent extends Equatable{
  const TypingNotificationEvent();

  factory TypingNotificationEvent.onSunscibed(User user, {required List<String> usersWithChat}) => Sunscribed(user, usersWithChat: usersWithChat);
  factory TypingNotificationEvent.onTypingSent(List<TypingEvent> events) => TypingSent(events);

  @override
  List<Object> get props => [];
}

class Sunscribed extends TypingNotificationEvent {
  final User user;
  final List<String> usersWithChat;
  const Sunscribed(this.user, {required List<String> this.usersWithChat});
  @override
  List<Object> get props => [user];
}
class NotSunscribed extends TypingNotificationEvent {

}
class TypingSent extends TypingNotificationEvent {
  final List<TypingEvent> events;
  const TypingSent(this.events);
  @override
  List<Object> get props => [events];
}

class TypingReceived extends TypingNotificationEvent {
  final TypingEvent event;
  const TypingReceived(this.event);
  @override
  List<Object> get props => [event];
}