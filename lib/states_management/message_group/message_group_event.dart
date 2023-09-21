part of "message_group_bloc.dart";

abstract class MessageGroupEvent extends Equatable{
  const MessageGroupEvent();

  factory MessageGroupEvent.onSunscibed(User user) => Sunscribed(user);
  factory MessageGroupEvent.onGroupCreated(MessageGroup group) => MessageGroupSent(group);

  @override
  List<Object> get props => [];
}

class Sunscribed extends MessageGroupEvent {
  final User user;
  const Sunscribed(this.user);
  @override
  List<Object> get props => [user];
}
class NotSunscribed extends MessageGroupEvent {

}
class MessageGroupSent extends MessageGroupEvent {
  final MessageGroup group;
  const MessageGroupSent(this.group);
  @override
  List<Object> get props => [group];
}

class groupReceived extends MessageGroupEvent {
  final MessageGroup group;
  const groupReceived(this.group);
  @override
  List<Object> get props => [group];
}