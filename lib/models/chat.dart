import 'package:chat1/chat.dart';
import 'package:chat2/models/local_message.dart';

class Chat {
  String _id;
  int unread = 0;
  late List<LocalMessage> messages = [];
  late LocalMessage mostRecent;
  late User _from;


  set from(User value) {
    _from = value;
  }

  User get from => _from;

  Chat(
      this._id,
      // {
      //   this.messages,
      //   this.mostRecent
      // }
      );


  String get id => _id;

  toMap() => {'id': _id};
  factory Chat.fromMap(Map<String, dynamic> json) => Chat(json['id']);

}