part of './message_bloc.dart';

abstract class MessageState extends Equatable {

  const MessageState();
  factory MessageState.initial()=> MessageInitial();
  factory MessageState.sent(Message message)=> MessageSentSuccess(message);
  factory MessageState.received(Message message)=> MessageReceivedSuccess(message);



  @override
  List<Object> get props => [];

}
class MessageInitial extends MessageState {


}

class MessageSentSuccess extends MessageState {
  final Message _message;
  const MessageSentSuccess(this._message);
  @override
  List<Object> get props => [_message];

  Message get message => _message;
}

class MessageReceivedSuccess extends MessageState {
  final Message _message;
  const MessageReceivedSuccess(this._message);
  Message get message => _message;
  @override
  List<Object> get props => [_message];
}