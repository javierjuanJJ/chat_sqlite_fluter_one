part of './message_bloc.dart';
abstract class MessageEvent extends Equatable{
  const MessageEvent();

  factory MessageEvent.onSunscibed(User user) => Sunscribed(user);
  factory MessageEvent.onMessageSent(Message message) => MessageSent(message);

  @override
  List<Object> get props => [];
}

class Sunscribed extends MessageEvent {
  final User user;
  const Sunscribed(this.user);
  @override
  List<Object> get props => [user];
}

class MessageSent extends MessageEvent {
  final Message message;
  const MessageSent(this.message);
  @override
  List<Object> get props => [message];
}

class _MessageReceived extends MessageEvent {
  final Message message;
  const _MessageReceived(this.message);
  @override
  List<Object> get props => [message];
}