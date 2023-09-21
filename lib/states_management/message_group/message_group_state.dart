part of "message_group_bloc.dart";

abstract class MessageGroupState extends Equatable {
  const MessageGroupState();
  factory MessageGroupState.initial()=> MessageGroupInitial();
  factory MessageGroupState.created(MessageGroup group)=> MessageGroupCreatedSuccess(group);
  factory MessageGroupState.received(MessageGroup group)=> MessageGroupReceived(group);



  @override
  List<Object> get props => [];

}
class MessageGroupInitial extends MessageGroupState {

}

class MessageGroupCreatedSuccess extends MessageGroupState {
  final MessageGroup _group;

  MessageGroup get group => _group;

  MessageGroupCreatedSuccess(this._group);
  @override
  List<Object> get props => [_group];
}

class MessageGroupReceived extends MessageGroupState {
  final MessageGroup _group;
  MessageGroup get group => _group;
  const MessageGroupReceived(this._group);
  @override
  List<Object> get props => [_group];
}