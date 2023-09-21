part of './message_bloc.dart';
abstract class MessageEvent extends Equatable{
  const MessageEvent();

  factory MessageEvent.onSunscibed(User user) => Sunscribed(user);
  factory MessageEvent.onMessageSent(List<Message> messages) => MessageSent(messages);

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
  final List<Message> messages;
  const MessageSent(this.messages);
  @override
  List<Object> get props => [messages];
}

class _MessageReceived extends MessageEvent {
  final Message message;
  const _MessageReceived(this.message);
  @override
  List<Object> get props => [message];
}