import 'package:chat1/chat.dart';
import 'package:chat2/models/local_message.dart';

class Chat {
  String id;
  int unread = 0;
  late List<LocalMessage> messages = [];
  late LocalMessage mostRecent;

  Chat(
      this.id,
      // {
      //   this.messages,
      //   this.mostRecent
      // }
      );

  toMap() => {'id': id};
  factory Chat.fromMap(Map<String, dynamic> json) => Chat(json['id']);

}